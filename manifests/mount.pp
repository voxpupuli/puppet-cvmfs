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
  $cvmfs_uid_map = undef,
  $cvmfs_gid_map = undef,
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

  $_cvmfs_id_map_file_prefix = "/etc/cvmfs/config.d/${repo}"
  if $cvmfs_uid_map {
    cvmfs::id_map{ "${_cvmfs_id_map_file_prefix}.uid_map":
      map => $cvmfs_uid_map,
    }
  }
  if $cvmfs_gid_map {
    cvmfs::id_map{ "${_cvmfs_id_map_file_prefix}.gid_map":
      map => $cvmfs_gid_map,
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

