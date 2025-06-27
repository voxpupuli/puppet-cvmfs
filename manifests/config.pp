# @summary Central configuration of CVMFS
# @api private
#
class cvmfs::config (
  Enum['autofs','mount','none'] $mount_method                         = $cvmfs::mount_method,
  Boolean $manage_autofs_service                                      = $cvmfs::manage_autofs_service,
  Variant[Undef, String] $cvmfs_http_proxy                            = $cvmfs::cvmfs_http_proxy,
  Variant[Enum['auto'],Integer] $cvmfs_quota_limit                    = $cvmfs::cvmfs_quota_limit,
  Float $cvmfs_quota_ratio                                            = $cvmfs::cvmfs_quota_ratio,
  Stdlib::Absolutepath $cvmfs_cache_base                              = $cvmfs::cvmfs_cache_base,
  Optional[Stdlib::Absolutepath] $cvmfs_tracefile                     = $cvmfs::cvmfs_tracefile,
  Optional[Stdlib::Absolutepath] $cvmfs_debuglog                      = $cvmfs::cvmfs_debuglog,
  Optional[Integer] $cvmfs_max_ttl                                    = $cvmfs::cvmfs_max_ttl,
  Boolean $cvmfs_repo_list                                            = $cvmfs::cvmfs_repo_list,
  Optional[Integer] $cvmfs_memcache_size                              = $cvmfs::cvmfs_memcache_size,
  Optional[Enum['yes','no']] $cvmfs_claim_ownership                   = $cvmfs::cvmfs_claim_ownership,
  Optional[Integer[1,2]] $cvmfs_syslog_level                          = $cvmfs::cvmfs_syslog_level,
  Optional[Hash[Variant[Integer,String], Integer, 1]] $cvmfs_uid_map  = $cvmfs::cvmfs_uid_map,
  Optional[Hash[Variant[Integer,String], Integer, 1]] $cvmfs_gid_map  = $cvmfs::cvmfs_gid_map,
  Boolean $cvmfs_instrument_fuse                                      = $cvmfs::cvmfs_instrument_fuse,
  Optional[Enum['yes','no']] $cvmfs_mount_rw                          = $cvmfs::cvmfs_mount_rw,
  Integer $default_cvmfs_partsize                                     = $cvmfs::default_cvmfs_partsize,
  Optional[Integer] $cvmfs_timeout                                    = $cvmfs::cvmfs_timeout,
  Optional[Integer] $cvmfs_timeout_direct                             = $cvmfs::cvmfs_timeout_direct,
  Optional[Integer] $cvmfs_nfiles                                     = $cvmfs::cvmfs_nfiles,
  Hash $cvmfs_env_variables                                           = $cvmfs::cvmfs_env_variables,
  Optional[Enum['yes','no']] $cvmfs_use_geoapi                        = $cvmfs::cvmfs_use_geoapi,
  Optional[Enum['yes','no']] $cvmfs_follow_redirects                  = $cvmfs::cvmfs_follow_redirects,
  Optional[String] $cvmfs_alien_cache                                 = $cvmfs::cvmfs_alien_cache,
  Optional[Enum['yes','no']] $cvmfs_shared_cache                      = $cvmfs::cvmfs_shared_cache,
  Optional[Variant[Integer[4,4],Integer[6,6]]] $cvmfs_ipfamily_prefer = $cvmfs::cvmfs_ipfamily_prefer,
  Optional[Integer] $cvmfs_dns_max_ttl                                = $cvmfs::cvmfs_dns_max_ttl,
  Optional[Integer] $cvmfs_dns_min_ttl                                = $cvmfs::cvmfs_dns_min_ttl,
  Optional[Enum['yes','no']] $cvmfs_cache_symlinks                    = $cvmfs::cvmfs_cache_symlinks,
  Optional[Enum['yes','no']] $cvmfs_streaming_cache                   = $cvmfs::cvmfs_streaming_cache,
  Optional[Enum['yes','no']] $cvmfs_cache_refcount                    = $cvmfs::cvmfs_cache_refcount,
  Optional[Integer[1]] $cvmfs_statfs_cache_timeout                    = $cvmfs::cvmfs_statfs_cache_timeout,
  Optional[Enum['yes','no']] $cvmfs_world_readable                    = $cvmfs::cvmfs_world_readable,
  Optional[Array[Integer[0],1]] $cvmfs_cpu_affinity                   = $cvmfs::cvmfs_cpu_affinity,
  Optional[Array[Integer[1],1]] $cvmfs_xattr_privileged_gids          = $cvmfs::cvmfs_xattr_privileged_gids,
  Optional[Array[String[1],1]] $cvmfs_xattr_protected_xattrs          = $cvmfs::cvmfs_xattr_protected_xattrs,
  Optional[String[1]] $cvmfs_repositories                             = $cvmfs::cvmfs_repositories,
) inherits cvmfs {
  # If cvmfspartsize fact exists use it, otherwise use a sensible default.
  if $facts['cvmfspartsize'] {
    $_cvmfs_partsize = $facts['cvmfspartsize']
  } else {
    $_cvmfs_partsize = $default_cvmfs_partsize
  }

  case $cvmfs_quota_limit {
    'auto':  { $_cvmfs_quota_limit = Integer($cvmfs_quota_ratio * $_cvmfs_partsize) }
    default: { $_cvmfs_quota_limit = $cvmfs_quota_limit }
  }

  # Clobber the /etc/cvmfs/(domain|config).d directories.
  # This puppet module just does not support
  # concept of these directories so it's safer to clean them.
  file { ['/etc/cvmfs/domain.d', '/etc/cvmfs/config.d']:
    ensure  => directory,
    purge   => true,
    recurse => true,
    ignore  => '*.conf',
    owner   => root,
    group   => root,
    mode    => '0755',
  }
  file { '/etc/cvmfs/domain.d/README.PUPPET':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "This directory is managed by puppet but *.conf files are ignored from purging\n",
  }
  file { '/etc/cvmfs/config.d/README.PUPPET':
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
  concat { '/etc/cvmfs/default.local':
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  # UID and GID map are stored in separate files and included in the config.
  $_cvmfs_id_map_file_prefix = '/etc/cvmfs/config.d/default'
  if $cvmfs_uid_map {
    cvmfs::id_map { "${_cvmfs_id_map_file_prefix}.uid_map":
      map => $cvmfs_uid_map,
    }
  }
  if $cvmfs_gid_map {
    cvmfs::id_map { "${_cvmfs_id_map_file_prefix}.gid_map":
      map => $cvmfs_gid_map,
    }
  }
  concat::fragment { 'cvmfs_default_local_header':
    target  => '/etc/cvmfs/default.local',
    order   => 0,
    content => epp('cvmfs/repo.local.epp', {
        'cvmfs_http_proxy'             => $cvmfs_http_proxy,
        'cvmfs_cache_base'             => $cvmfs_cache_base,
        'cvmfs_timeout'                => $cvmfs_timeout,
        'cvmfs_timeout_direct'         => $cvmfs_timeout_direct,
        'cvmfs_nfiles'                 => $cvmfs_nfiles,
        'cvmfs_syslog_level'           => $cvmfs_syslog_level,
        'cvmfs_tracefile'              => $cvmfs_tracefile,
        'cvmfs_debuglog'               => $cvmfs_debuglog,
        'cvmfs_max_ttl'                => $cvmfs_max_ttl,
        'cvmfs_uid_map'                => $cvmfs_uid_map,
        'cvmfs_gid_map'                => $cvmfs_gid_map,
        'cvmfs_id_map_file_prefix'     => $_cvmfs_id_map_file_prefix,
        'cvmfs_quota_limit'            => $_cvmfs_quota_limit,
        'cvmfs_memcache_size'          => $cvmfs_memcache_size,
        'cvmfs_claim_ownership'        => $cvmfs_claim_ownership,
        'cvmfs_ipfamily_prefer'        => $cvmfs_ipfamily_prefer,
        'cvmfs_dns_max_ttl'            => $cvmfs_dns_max_ttl,
        'cvmfs_dns_min_ttl'            => $cvmfs_dns_min_ttl,
        'cvmfs_instrument_fuse'        => $cvmfs_instrument_fuse,
        'cvmfs_mount_rw'               => $cvmfs_mount_rw,
        'cvmfs_env_variables'          => $cvmfs_env_variables,
        'cvmfs_use_geoapi'             => $cvmfs_use_geoapi,
        'cvmfs_follow_redirects'       => $cvmfs_follow_redirects,
        'cvmfs_alien_cache'            => $cvmfs_alien_cache,
        'cvmfs_shared_cache'           => $cvmfs_shared_cache,
        'cvmfs_cache_symlinks'         => $cvmfs_cache_symlinks,
        'cvmfs_streaming_cache'        => $cvmfs_streaming_cache,
        'cvmfs_cache_refcount'         => $cvmfs_cache_refcount,
        'cvmfs_statfs_cache_timeout'   => $cvmfs_statfs_cache_timeout,
        'cvmfs_world_readable'         => $cvmfs_world_readable,
        'cvmfs_cpu_affinity'           => $cvmfs_cpu_affinity,
        'cvmfs_xattr_privileged_gids'  => $cvmfs_xattr_privileged_gids,
        'cvmfs_xattr_protected_xattrs' => $cvmfs_xattr_protected_xattrs,
      }
    ),
  }

  if $cvmfs_repositories {
    concat::fragment { 'cvmfs_default_local_repo':
      target  => '/etc/cvmfs/default.local',
      order   => 5,
      content => "CVMFS_REPOSITORIES='${cvmfs_repositories}'\n",
    }
  } elsif $cvmfs_repo_list {
    concat::fragment { 'cvmfs_default_local_repo_end':
      target  => '/etc/cvmfs/default.local',
      order   => 7,
      content => "'\n\n",
    }
    concat::fragment { 'cvmfs_default_local_repo_start':
      target  => '/etc/cvmfs/default.local',
      order   => 5,
      content => 'CVMFS_REPOSITORIES=\'',
    }
  }

  if $mount_method == 'autofs' {
    file { '/etc/auto.master.d/cvmfs.autofs':
      ensure  => file,
      content => "# Puppet installed\n/cvmfs  program:/etc/auto.cvmfs\n",
      owner   => root,
      group   => root,
      mode    => '0644',
    }
  }
}
