# == Define: cvmfs::mount
define cvmfs::mount($cvmfs_quota_limit = undef,
  $cvmfs_server_url = undef,
  $cvmfs_http_proxy = undef,
  $cvmfs_timeout = undef,
  $cvmfs_timeout_direct = undef,
  $cvmfs_nfiles = undef,
  $cvmfs_public_key = undef,
  $cvmfs_force_singing = undef,
  $cvmfs_max_ttl = undef,
  $cvmfs_env_variables = undef,
  $cvmfs_use_geoapi = undef,
  $cvmfs_repo_list = true,
  $cmvfs_mount_rw = undef,
  $cvmfs_memcache_size = undef,
  $cvmfs_claim_ownership = undef,
  $cvmfs_uid_map = {},
  $cvmfs_gid_map = {},
  $cvmfs_follow_redirects = undef,
  $mount_options = 'defaults,_netdev,nodev',
  $mount_method = $cvmfs::mount_method,
  Optional[String] $cvmfs_external_fallback_proxy = undef,
  Optional[String] $cvmfs_external_http_proxy = undef,
  Optional[Integer] $cvmfs_external_timeout = undef,
  Optional[Integer] $cvmfs_external_timeout_direct = undef,
  Optional[String] $cvmfs_external_url = undef,
  Optional[String[1]] $cvmfs_repository_tag = undef,
) {

  include ::cvmfs

  $repo = $name

  # UID and GID map are stored in separate files and included in the config.
  $_cvmfs_id_map_file_prefix = "/etc/cvmfs/config.d/${repo}"
  [ 'uid', 'gid' ].each |$_idt| {
    $_cvmfs_id_map = getvar("cvmfs_${_idt}_map")
    if $_cvmfs_id_map.length() > 0 {
      concat{"${_cvmfs_id_map_file_prefix}.${_idt}_map":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Class['cvmfs::install'],
        notify  => Class['cvmfs::service'],
      }
      Concat["${_cvmfs_id_map_file_prefix}.${_idt}_map"] -> File["/etc/cvmfs/config.d/${repo}.local"]
      concat::fragment{"cvmfs_${_idt}_map_${repo}_header":
        target  => "${_cvmfs_id_map_file_prefix}.${_idt}_map",
        order   => '01',
        content => "# Created by puppet.\n\n",
        notify  => Class['cvmfs::service'],
      }
      $_cvmfs_id_map.each |$_from_id, $_to_id| {
        concat::fragment{"cvmfs_${_idt}_map_${repo}_from_${_from_id}_to_${_to_id}":
          target  => "${_cvmfs_id_map_file_prefix}.${_idt}_map",
          order   => '10',
          content => "${_from_id} ${_to_id}\n",
          notify  => Class['cvmfs::service'],
        }
      }
    }
  }

  file{"/etc/cvmfs/config.d/${repo}.local":
    ensure  =>  file,
    content => template('cvmfs/repo.local.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['cvmfs::install'],
    notify  => Class['cvmfs::service'],
  }
  if $cvmfs_repo_list and $cvmfs::cvmfs_repositories =~ Undef {
    concat::fragment{"cvmfs_default_local_${repo}":
      target  => '/etc/cvmfs/default.local',
      order   => 6,
      content => "${repo},",
    }
  }
  if $mount_method == 'mount' {
    file{"/cvmfs/${repo}":
      ensure  => directory,
      owner   => 'cvmfs',
      group   => 'cvmfs',
      require => Package['cvmfs'],
    }
    mount{"/cvmfs/${repo}":
      ensure  => mounted,
      device  => $repo,
      fstype  => 'cvmfs',
      options => $mount_options,
      atboot  => true,
      require => [File["/cvmfs/${repo}"],File["/etc/cvmfs/config.d/${repo}.local"],Concat['/etc/cvmfs/default.local'],File['/etc/fuse.conf']],
    }
  }
}

