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
  $mount_method                        = $cvmfs::mount_method,
  $manage_autofs_service               = $cvmfs::manage_autofs_service,
  $cvmfs_quota_limit                   = $cvmfs::cvmfs_quota_limit,
  $cvmfs_quota_ratio                   = $cvmfs::cvmfs_quota_ratio,
  $cvmfs_repo_list                     = $cvmfs::cvmfs_repo_list,
  $cvmfs_memcache_size                 = $cvmfs::cvmfs_memcache_size,
  $cvmfs_claim_ownership               = $cvmfs::cvmfs_claim_ownership,
  $cvmfs_uid_map                       = $cvmfs::cvmfs_uid_map,
  $cvmfs_gid_map                       = $cvmfs::cvmfs_gid_map,
  $default_cvmfs_partsize              = $cvmfs::default_cvmfs_partsize,
  Optional[Integer] $cvmfs_dns_max_ttl = $cvmfs::cvmfs_dns_max_ttl,
  Optional[Integer] $cvmfs_dns_min_ttl = $cvmfs::cvmfs_dns_min_ttl,
  $cvmfs_repositories                  = $cvmfs::cvmfs_repositories,
) inherits cvmfs {

  # If cvmfspartsize fact exists use it, otherwise use a sensible default.
  if getvar(::cvmfspartsize) {
    $_cvmfs_partsize = $::cvmfspartsize
  } else {
    $_cvmfs_partsize = $default_cvmfs_partsize
  }


  case $cvmfs_quota_limit {
    'auto':  { $my_cvmfs_quota_limit = sprintf('%i',$cvmfs_quota_ratio *  $_cvmfs_partsize) }
    default: { $my_cvmfs_quota_limit = $cvmfs_quota_limit }
  }

  # Clobber the /etc/cvmfs/(domain|config).d directories.
  # This puppet module just does not support
  # concept of these directories so it's safer to clean them.
  file{ ['/etc/cvmfs/domain.d', '/etc/cvmfs/config.d']:
    ensure  => directory,
    purge   => true,
    recurse => true,
    ignore  => '*.conf',
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
  }
  file{'/etc/cvmfs/config.d/README.PUPPET':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "This directory is managed by puppet but *.conf files are ignored from purging\n",
  }

  # Clobber the /etc/fuse.conf, hopefully no
  # one else wants it.
  ensure_resource('file','/etc/fuse.conf',
    {
      ensure  => present,
      content => "#Installed with puppet\nuser_allow_other\n",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  )
  concat{'/etc/cvmfs/default.local':
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  # UID and GID map are stored in separate files and included in the config.
  $_cvmfs_id_map_file_prefix = '/etc/cvmfs/config.d/default'
  if $cvmfs_uid_map {
    cvmfs::id_map{"${_cvmfs_id_map_file_prefix}.uid_map":
      map => $cvmfs_uid_map,
    }
  }
  if $cvmfs_gid_map {
    cvmfs::id_map{"${_cvmfs_id_map_file_prefix}.gid_map":
      map => $cvmfs_gid_map,
    }
  }
  concat::fragment{'cvmfs_default_local_header':
    target  => '/etc/cvmfs/default.local',
    order   => 0,
    content => template('cvmfs/repo.local.erb'),
  }

  if $cvmfs_repositories {
    concat::fragment{'cvmfs_default_local_repo':
      target  => '/etc/cvmfs/default.local',
      order   => 5,
      content => "CVMFS_REPOSITORIES='${cvmfs_repositories}'\n",
    }
  } elsif $cvmfs_repo_list {
    concat::fragment{'cvmfs_default_local_repo_end':
      target  => '/etc/cvmfs/default.local',
      order   => 7,
      content => "'\n\n",
    }
    concat::fragment{'cvmfs_default_local_repo_start':
      target  => '/etc/cvmfs/default.local',
      order   => 5,
      content => 'CVMFS_REPOSITORIES=\'',
    }
  }

  if $mount_method == 'autofs' {
    if versioncmp($facts['os']['release']['major'],'7') <= 0 {
      augeas{'cvmfs_automaster':
        context => '/files/etc/auto.master/',
        lens    => 'Automaster.lns',
        incl    => '/etc/auto.master',
        changes => [
          'set 01      /cvmfs',
          'set 01/type program',
          'set 01/map  /etc/auto.cvmfs',
        ],
        onlyif  => 'match *[map="/etc/auto.cvmfs"] size == 0',
      }
    } else {
      file{'/etc/auto.master.d/cvmfs.autofs':
        ensure  => file,
        content => "Puppet installed\n/cvmfs  program:/etc/auto.cvmfs\n",
        owner   => root,
        group   => root,
        mode    => '0644',
      }
    }
  }
}
