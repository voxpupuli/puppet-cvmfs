# == Class: cvmfs::config
#
# Configures generic configuration for all cvmfs mounts.
#
# === Parameters
#
# [*config_automaster*]
#   This module can configure autofs in addition to cvmfs but at
#   some locations this may not be sensible. Set to 'false'  to
#   stop this module configuring autofs.
#
# [*cvmfs_quota_limit*]
#   For all parameters cvmfs_* this sets a value in
#   /etc/cvmfs/default.local. e.g config_quota_limit
#   set CVMFS_QUOTA_LIMIT in the default.local file.
#   The same is true for cvmfs_* variables.
#   See params.pp for defaults.
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
  $major_release              = $cvmfs::params::major_release,
  $config_automaster          = $cvmfs::params::config_automaster,
  $cvmfs_quota_limit          = $cvmfs::params::cvmfs_quota_limit,
  $cvmfs_quota_ratio          = $cvmfs::params::cvmfs_quota_ratio,
  $cvmfs_http_proxy           = $cvmfs::params::cvmfs_http_proxy,
  $cvmfs_server_url           = $cvmfs::params::cvmfs_server_url,
  $cvmfs_cache_base           = $cvmfs::params::cvmfs_cache_base,
  $default_cvmfs_cache_base   = $cvmfs::params::default_cvmfs_cache_base,
  $cvmfs_timeout              = $cvmfs::params::cvmfs_timeout,
  $cvmfs_timeout_direct       = $cvmfs::params::cvmfs_timeout_direct,
  $cvmfs_nfiles               = $cvmfs::params::cvmfs_nfiles,
  $cvmfs_public_key           = $cvmfs::params::cvmfs_public_key,
  $cvmfs_force_signing        = $cvmfs::params::cvmfs_force_signing,
  $cvmfs_syslog_level         = $cvmfs::params::cvmfs_syslog_level,
  $cvmfs_tracefile            = $cvmfs::params::cvmfs_tracefile,
  $cvmfs_debuglog             = $cvmfs::params::cvmfs_debuglog,
  $cvmfs_max_ttl              = $cvmfs::params::cvmfs_max_ttl
) inherits cvmfs::params{

  case $::cvmfsversion {
    /^2\.[01]\.*/: { }
      default: { info('This cvmfs module is only checked with cvmfs version 2.0.X and 2.1.X currently.')
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
    content => "This directory has been purged by puppet,\nthe puppet module does not support this directory.\n",
    require => File['/etc/cvmfs/domain.d']
  }

  # Clobber the /etc/fuse.conf, hopefully no
  # one else wants it.
  file{'/etc/fuse.conf':
    ensure  => present,
    content => "#Installed with puppet cvmfs::config\nuser_allow_other\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['cvmfs::service']
  }
  concat{'/etc/cvmfs/default.local':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['cvmfs::install'],
    notify  => Class['cvmfs::service']
  }
  concat::fragment{'cvmfs_default_local_header':
    target  => '/etc/cvmfs/default.local',
    order   => 0,
    content => template('cvmfs/repo.local.erb')
  }

  if $config_automaster == 'true' {
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
        'set 01/map  /etc/auto.cvmfs'
      ],
      onlyif    => 'match *[map="/etc/auto.cvmfs"] size == 0',
      notify    => Service['autofs']
    }
  }
}
