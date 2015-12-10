# == Class: cvmfs::config
#
# Configures generic configuration for all cvmfs mounts.
#
# === Authors
#
# Steve Traylen <steve.traylen@cern.ch>
#
# === Copyright
#
# Copyright 2012 CERN
#
class cvmfs::config (
  $config_automaster  = $cvmfs::config_automaster,
  $cvmfs_quota_limit  = $cvmfs::cvmfs_quota_limit,
  $cvmfs_quota_ratio  = $cvmfs::cvmfs_quota_ratio
) inherits cvmfs {

  case $::cvmfsversion {
    /^2\.[01]\.*/: { }
      default: { warning('This cvmfs module is only checked with cvmfs version 2.0.X and 2.1.X currently.')
    }
  }

  case $cvmfs_quota_limit {
    'auto':  { $my_cvmfs_quota_limit = sprintf('%i',$cvmfs_quota_ratio *  $::cvmfspartsize) }
    default: { $my_cvmfs_quota_limit = $cvmfs_quota_limit }
  }

  # Clobber the /etc/cvmfs/domain.d directory.
  # This puppet module just does not support
  # concept of this directory so it's safer to clean it.
  file{'/etc/cvmfs/domain.d':
    ensure  => directory,
    purge   => true,
    recurse => true,
    ignore  => '*.conf',
    require => Package['cvmfs'],
    owner   => root,
    group   => root,
    mode    => '0755',
  }
  file{'/etc/cvmfs/domain.d/README.PUPPET':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "This directory is managed by puppet but *.conf files are ignored from purging\n",
    require => File['/etc/cvmfs/domain.d'],
  }

  # Clobber the /etc/fuse.conf, hopefully no
  # one else wants it.
  file{'/etc/fuse.conf':
    ensure  => present,
    content => "#Installed with puppet cvmfs::config\nuser_allow_other\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['cvmfs::service'],
  }
  concat{'/etc/cvmfs/default.local':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['cvmfs::install'],
    notify  => Class['cvmfs::service'],
  }
  concat::fragment{'cvmfs_default_local_header':
    target  => '/etc/cvmfs/default.local',
    order   => 0,
    content => template('cvmfs/repo.local.erb'),
  }

  if str2bool($config_automaster) {
    # Use the automaster.aug lens from a future version of augeas
    # This can be dropped once newer than 0.10.0 is everywhere I expect.
    # This may also go wrong if there is a point release of augeas.
    case $::augeasversion {
      '0.9.0','0.10.0': { $lenspath = '/var/lib/puppet/lib/augeas/lenses' }
      default: { $lenspath = undef }
    }
    augeas{'cvmfs_automaster':
      context   => '/files/etc/auto.master/',
      lens      => 'Automaster.lns',
      incl      => '/etc/auto.master',
      load_path => $lenspath,
      changes   => [
        'set 01      /cvmfs',
        'set 01/type program',
        'set 01/map  /etc/auto.cvmfs',
      ],
      onlyif    => 'match *[map="/etc/auto.cvmfs"] size == 0',
      notify    => Service['autofs'],
    }
  }
}
