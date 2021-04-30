# @summary
#   Mount one cvmfs repository. Most parameters map as lower case
#   versions of the raw cvmfs parameters.
#
# @see https://cvmfs.readthedocs.io/en/stable/apx-parameters.html CVMFS configuration parameters
#
# @example Trivial Mount
#   cvmfs::mount{'files.example.org:
#     cvmfs_server_url => 'http://web.exampple.org/cvmfs/files.example.org',
#   }
#
# @example Mount with Environment Variables.
#   cvmfs::mount{'foobar.example.org':
#     cvmfs_env_variables => {
#       'FOOT' => 'ball',
#       'GOLF' => 'club',
#     }
#   }
#
# @param repo The fully qualified repository name to mount
# @param cvmfs_quota_limit Per mount quota limit, not relavent to shared cache. Sets cvmfs_quota_limit
# @param cvmfs_server_url Stratum 1 list, typically `;` delimited. Sets CVMFS_SERVER_URL parameter.
# @param cvmfs_http_proxy List of http proxies to use. Sets CVMFS_PROXY_LIST parameter.
# @param cvmfs_timeout Sets CVMFS_HTTP_TIMEOUT parameter
# @param cvmfs_timeout_direct Sets CVMFS_HTTP_TIMEOUT_DIRECT
# @param cvmfs_nfiles Number of open files permitted on the OS. Sets CVMFS_NFILES
# @param cvmfs_public_key Public key of repository, sets CVMFS_PUBLIC_KEYS
# @param cvmfs_keys_dir Directory with publice keys for repository, sets CVMFS_KEYS_DIR
# @param cvmfs_max_ttl Maximum effective TTL in seconds for DNS queries of proxy server names. Sets CVMFS_MAX_TTL
# @param cvmfs_env_variables Sets per repo environments variables for magic links.
# @param cvmfs_use_geoapi Set CVMFS_MAX_GEOAPI
# @param mount_method Should the mount attempt be made with autofs or tranditional fstab mount. Do no use this.
# @param cvmfs_repo_list If true the repository will added to the list of repositories maintained in `/etc/cvmfs/default.local`
# @param cvmfs_mount_rw sets CVMFS_MOUNT_RW
# @param cvmfs_memcache_size Sets CVMFS_MEMCACHE_SIZE in Megabytes.
# @param cvmfs_claim_ownership Sets CVMFS_CLAIM_OWNERSHIP.
# @param cvmfs_uid_map Specify a UID map file path for this repository . Sets CVMFS_UID_MAP
# @param cvmfs_gid_map Specify a GID map file path for this repository . Sets CVMFS_GID_MAP
# @param cvmfs_follow_redirects Sets CVMFS_FOLLOW_REDIRECTS.
# @param cvmfs_external_fallback_proxy Sets CVMFS_EXTERNAL_FALLBACK_PROXY
# @param cvmfs_external_http_proxy Sets CVMFS_EXTERNAL_HTTP_PROXY
# @param cvmfs_external_timeout Sets CVMFS_EXTERNAL_TIMEOUT
# @param cvmfs_external_timeout_direct Sets CVMFS_EXTERNAL_TIMEOUT_DIRECT
# @param cvmfs_external_url Sets CVMFS_EXTERNAL_URL
# @param cvmfs_repository_tag Sets CVMFS_REPOSITORY_TAG
# @param mount_options Mount options to use for fstab style mounting.
#
define cvmfs::mount (
  Stdlib::Fqdn $repo                                                = $name,
  Optional[Integer]  $cvmfs_quota_limit                             = undef,
  Optional[String[1]] $cvmfs_server_url                             = undef,
  Optional[String[1]] $cvmfs_http_proxy                             = undef,
  Optional[Integer] $cvmfs_timeout                                  = undef,
  Optional[Integer] $cvmfs_timeout_direct                           = undef,
  Optional[Integer] $cvmfs_nfiles                                   = undef,
  Optional[String[1]] $cvmfs_public_key                             = undef,
  Optional[Stdlib::Absolutepath] $cvmfs_keys_dir                    = undef,
  Optional[Integer] $cvmfs_max_ttl                                  = undef,
  Optional[Hash] $cvmfs_env_variables                               = undef,
  Optional[Stdlib::Yes_no] $cvmfs_use_geoapi                        = undef,
  Boolean$cvmfs_repo_list                                           = true,
  Optional[Stdlib::Yes_no] $cvmfs_mount_rw                          = undef,
  Optional[Integer] $cvmfs_memcache_size                            = undef,
  Optional[Stdlib::Yes_no] $cvmfs_claim_ownership                   = undef,
  Optional[Hash[Variant[Integer,String],Integer, 1]] $cvmfs_uid_map = undef,
  Optional[Hash[Variant[Integer,String],Integer, 1]] $cvmfs_gid_map = undef,
  Optional[Stdlib::Yes_no] $cvmfs_follow_redirects                  = undef,
  String[1] $mount_options                                          = 'defaults,_netdev,nodev',
  Enum['autofs','mount','none'] $mount_method                       = $cvmfs::mount_method,
  Optional[String] $cvmfs_external_fallback_proxy                   = undef,
  Optional[String] $cvmfs_external_http_proxy                       = undef,
  Optional[Integer] $cvmfs_external_timeout                         = undef,
  Optional[Integer] $cvmfs_external_timeout_direct                  = undef,
  Optional[String] $cvmfs_external_url                              = undef,
  Optional[String[1]] $cvmfs_repository_tag                         = undef,
) {
  include cvmfs

  $_cvmfs_id_map_file_prefix = "/etc/cvmfs/config.d/${repo}"
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

  file { "/etc/cvmfs/config.d/${repo}.local":
    ensure  => file,
    content => epp('cvmfs/repo.local.epp', {
        'repo'                          => $repo,
        'cvmfs_server_url'              => $cvmfs_server_url,
        'cvmfs_quota_limit'             => $cvmfs_quota_limit,
        'cvmfs_http_proxy'              => $cvmfs_http_proxy,
        'cvmfs_timeout'                 => $cvmfs_timeout,
        'cvmfs_timeout_direct'          => $cvmfs_timeout_direct,
        'cvmfs_nfiles'                  => $cvmfs_nfiles,
        'cvmfs_public_key'              => $cvmfs_public_key,
        'cvmfs_keys_dir'                => $cvmfs_keys_dir,
        'cvmfs_max_ttl'                 => $cvmfs_max_ttl,
        'cvmfs_env_variables'           => $cvmfs_env_variables,
        'cvmfs_use_geoapi'              => $cvmfs_use_geoapi,
        'cvmfs_mount_rw'                => $cvmfs_mount_rw,
        'cvmfs_memcache_size'           => $cvmfs_memcache_size,
        'cvmfs_claim_ownership'         => $cvmfs_claim_ownership,
        'cvmfs_id_map_file_prefix'      => $_cvmfs_id_map_file_prefix,
        'cvmfs_uid_map'                 => $cvmfs_uid_map,
        'cvmfs_gid_map'                 => $cvmfs_gid_map,
        'cvmfs_follow_redirects'        => $cvmfs_follow_redirects,
        'cvmfs_external_fallback_proxy' => $cvmfs_external_fallback_proxy,
        'cvmfs_external_timeout'        => $cvmfs_external_timeout,
        'cvmfs_external_timeout_direct' => $cvmfs_external_timeout_direct,
        'cvmfs_external_url'            => $cvmfs_external_url,
        'cvmfs_external_http_proxy'     => $cvmfs_external_http_proxy,
        'cvmfs_repository_tag'          => $cvmfs_repository_tag,
    }),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['cvmfs::install'],
    notify  => Class['cvmfs::service'],
  }
  if $cvmfs_repo_list and $cvmfs::cvmfs_repositories =~ Undef {
    concat::fragment { "cvmfs_default_local_${repo}":
      target  => '/etc/cvmfs/default.local',
      order   => 6,
      content => "${repo},",
    }
  }
  if $mount_method == 'mount' {
    file { "/cvmfs/${repo}":
      ensure  => directory,
      owner   => 'cvmfs',
      group   => 'cvmfs',
      require => Package['cvmfs'],
    }
    mount { "/cvmfs/${repo}":
      ensure  => mounted,
      device  => $repo,
      fstype  => 'cvmfs',
      options => $mount_options,
      atboot  => true,
      require => [File["/cvmfs/${repo}"],File["/etc/cvmfs/config.d/${repo}.local"],Concat['/etc/cvmfs/default.local'],File['/etc/fuse.conf']],
    }
  }
}
