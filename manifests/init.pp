# @summary Installs and Configures CVMFS
#
# @see https://cvmfs.readthedocs.io/en/stable/apx-parameters.html CVMFS configuration parameters
#
# @example Simple Example For one Mount
#   class{'cvmfs':
#     cvmfs_http_proxy => 'http://ca-proxy.example.org:3128',
#     cvmfs_quota_limit => 100
#   }
#   cvmfs::mount{'files.example.org:
#     cvmfs_server_url => 'http://web.example.org/cvmfs/files.example.org',
#   }
#
# @example Mount a Domain
#   class{'cvmfs':
#     cvmfs_http_proxy  => 'http://ca-proxy.example.org:3128',
#     cvmfs_quota_limit => 100,
#   }
#   cvmfs::domain{'example.net'
#     cvmfs_server_url => 'http://web.example.org/cvmfs/@fqrn@'
#   }
#
# @example Use Mount rather than AutoFS
#   class{'cvmfs':
#     mount_method => 'mount',
#   }
#
# @example Specify mounts as a hash
#   class{'cvmfs':
#     cvmfs_hash => {
#       'foo.example.org' => { 'cvmfs_server_url => 'http://web.example.org/cmfs/foo.example.org' },
#       'bar.example.org' => { 'cvmfs_server_url => 'http://web.example.org/cvmfs/bar.example.org' },
#     }
#   }
#
# @example New parameters with CVMFS 2.11.0
#  class{'cvmfs':
#    cvmfs_cache_symlinks => 'yes',
#    cvmfs_streaming_cache => 'no',
#    cvmfs_statfs_cache_timeout => 10,
#    cvmfs_world_readable => 'yes',
#    cvmfs_cpu_affinity => [0,1,2],
#    cvmfs_xattr_privileged_gids => [100,101,102],
#    cvmfs_xattr_protected_xattrs => ['user.foo','user.bar'],
#    cvmfs_cache_refcount => 'yes',
#  }
#
# @param mount_method
#    The `autofs` option will configure cvmfs to be mounted with autofs. The `mount` option will
#    use puppet's mount type, currently adding a line to /etc/fstab. The *none* option
#    skips all mounting.  Note that migrating between for instance *autofs* and then *mount* is not supported.
# @param config_repo
#    When using the `mount_method` as `mount` it may be nescessary to specify a CVMFS located configuration_repository.
#    This is a repository containing extra cvmfs configuration required to be mounted before any other
#    repositories. There is at most one config_repo client. In addition the config_repo must actually be mounted
#    explicitly with a `cvmfs::mount{$config_repo:}`, this is **not** automatic.
# @param manage_autofs_service should the autofs service be maintained.
# @param cvmfs_quota_limit The cvmfs quota size in megabytes.
# @param cvmfs_quota_ratio
#   If set , e.g '0.8', then 0.8 of the partition size
#   the cvmfs cache is on will be used. Setting this assumes you have
#   pre-allocated a partition to the cvmfs cache or else it makes little sense.
# @param cvmfs_http_proxy List of squid servers, e.g `http://squid1.example.org;http;//squid2.example.org`
# @param cvmfs_cache_base Location of the CVMFS cache base
# @param cvmfs_cache_owner expected owner of cvmfs cache
# @param cvmfs_cache_group expected group of cvmfs cache
# @param cvmfs_cache_mode  expected mode of cvmfs cache
# @param cvmfs_ipfamily_prefer Preferred IP protocol for dual-stack proxies. If not set, cvmfs default will be used.
# @param cvmfs_dns_min_ttl Minimum ttl of DNS lookups in seconds.
# @param cvmfs_dns_max_ttl Maximum ttl of DNS lookups in seconds.
# @param cvmfs_claim_ownership Whether the client claims ownership of files or not.
# @param cvmfs_uid_map Hash of UID pairs to map UIDs from catalogue to on the client.
# @param cvmfs_gid_map Hash of GID pairs to map GIDs from catalogue to on the client.
# @param cvmfs_memcache_size Size of the CernVM-FS meta-data memory cache in Megabyte.
# @param cvmfs_mount_rw Mount option to mount as read-only or read/write.
# @param cvmfs_follow_redirects Sets CVMFS_FOLLOW_REDIRECTS to its value
# @param cvmfs_timeout cvmfs timeout setting.
# @param cvmfs_timeout_direct cvmfs timeout to direct connections.
# @param cvmfs_nfiles Number of open files, system setting.
# @param cvmfs_syslog_level Level to syslog at.
# @param cvmfs_tracefile Create a tracefile at this location.
# @param cvmfs_debuglog Create a debug log file at this location.
# @param cvmfs_max_ttl Max ttl.
# @param cvmfs_version Version of cvmfs to install.
# @param repo_base URL containing stable, testing and config apt or yum repositories. Default in hiera data.
# @param repo_base_alt URL containing stable, Same as repo_base, hosted on a different backend. Default in hiera data.
# @param repo_includepkgs Specify an includepkgs to the yum repos to ignore other packages.
# @param repo_priority Yum priority of repositories
# @param repo_proxy http proxy for cvmfs yum package repository
# @param repo_config_enabled Should the config yum repository be enabled
# @param repo_testing_enabled Should the testing repository be enabled.
# @param repo_future_enabled Should the future (pre-release) repository be enabled.
# @param repo_gpgcheck  set to false to disable GPG checking
# @param repo_gpgkey Set a custom GPG key for yum repos. Default in hiera data.
# @param repo_manage Set to false to disable yum or apt repositories management.
# @param cvmfs_use_geoapi Enable geoapi to find suitable proxies.
# @param cvmfs_repositories
#   If undef `CVMFS_REPOSITORIES` in `default.local` will be populated
#   automatically from what is explicitly mounted with `cvmfs::mount`. If this is
#   specified then`CVMFS_REPOSITORIES` list in `default.local` will be exactly managed with this variable.
#   e.g `cvmfs-config.cern.ch,atlas.cern.ch`
# @param cvmfs_hash
#   Rather than using cvmfs::mount defined type a hash of mounts can be sepecfied.
# @param cvmfs_env_variables
#  `$cvmfs_env_variables = {'CMS_LOCAL_SITE' => '<path to siteconf>'`
#   will produce `export CMS_LOCAL_SITE=<path to siteconf>`in the default.local file.
# @param default_cvmfs_partsize
# @param cvmfs_domain_hash Specify of a hash `cvmfs::domain` types.
# @param cvmfs_instrument_fuse  Instrument Fuse
# @param cvmfs_repo_list Specify exactly the REPO_LIST in `defaults.local` overriding auto population.
# @param cvmfs_alien_cache Use an alien cache
# @param cvmfs_shared_cache Enable a shared cache
# @param cvmfs_fsck Ensure the cvmfs::fsck class is included.
# @param cvmfs_fsck_options Any extra options for cvmfs fsck
# @param cvmfs_fsck_onreboot Should fsck be run after every reboot
# @param cvmfs_cache_symlinks If set to yes, enables symlink caching in the kernel.
# @param cvmfs_streaming_cache If set to yes, use a download manager to download regular files on read.
# @param cvmfs_statfs_cache_timeout Caching time of statfs() in seconds (no caching by default).
# @param cvmfs_world_readable Override posix read permissions to make files in repository globally readable
# @param cvmfs_cpu_affinity Set CPU affinity for all cvmfs components.
# @param cvmfs_xattr_privileged_gids group IDs that are allowed to access the extended attributes by `$cvmfs_xattr_protected_xattrs`.
# @param cvmfs_xattr_protected_xattrs List of extended attributes (full name, e.g. user.fqrn) that are only accessible by root and the group IDs listed by `$cvmfs_xattr_privileged_gids`.
# @param cvmfs_cache_refcount If set to yes, deduplicate open file descriptors by refcounting.
#
# Deprecated paramters below
# @param cvmfs_yum Deprecated, use repo_base
# @param cvmfs_yum_priority Deprecated, use repo_priority
# @param cvmfs_yum_proxy Deprecated, user repo_proxy
# @param cvmfs_yum_config  Deprecated, use repo_base
# @param cvmfs_yum_config_enabled  Deprecated, user repo_config_enabled
# @param cvmfs_yum_testing Deprecated, use repo_base
# @param cvmfs_yum_testing_enabled Deprecated, use repo_testing_enabled
# @param cvmfs_yum_gpgcheck  Deprecated, use repo_gpgcheck
# @param cvmfs_yum_gpgkey Deprecated, use repo_gpgkey
# @param cvmfs_yum_manage_repo Deprecated, use repo_manage
# @param cvmfs_yum_includepkgs Deprecated, use repo_includepkgs
#
class cvmfs (
  Stdlib::Httpurl $repo_base,
  Stdlib::Httpurl $repo_base_alt,
  Stdlib::Httpurl $repo_gpgkey,
  Variant[Undef,String] $cvmfs_http_proxy,
  Optional[Variant[Enum['absent'], Array[String[1]]]] $repo_includepkgs,
  Enum['autofs','mount','none'] $mount_method                         = 'autofs',
  Optional[Stdlib::Fqdn] $config_repo                                 = undef,
  Boolean $manage_autofs_service                                      = true,
  Integer $default_cvmfs_partsize                                     = 10000,
  Variant[Enum['auto'],Integer] $cvmfs_quota_limit                    = 1000,
  Float   $cvmfs_quota_ratio                                          = 0.85,
  Stdlib::Absolutepath $cvmfs_cache_base                              = '/var/lib/cvmfs',
  String[1] $cvmfs_cache_owner                                        = 'cvmfs',
  String[1] $cvmfs_cache_group                                        = 'cvmfs',
  Stdlib::Filemode $cvmfs_cache_mode                                  = '0700',
  Optional[Enum['yes','no']] $cvmfs_claim_ownership                   = undef,
  Optional[Hash[Variant[Integer,String], Integer, 1]] $cvmfs_uid_map  = undef,
  Optional[Hash[Variant[Integer,String], Integer, 1]] $cvmfs_gid_map  = undef,
  Optional[Enum['yes','no']] $cvmfs_mount_rw                          = undef,
  Optional[Integer] $cvmfs_memcache_size                              = undef,
  Optional[Integer] $cvmfs_timeout                                    = undef,
  Optional[Integer] $cvmfs_timeout_direct                             = undef,
  Optional[Integer] $cvmfs_nfiles                                     = undef,
  Optional[Integer[1,2]] $cvmfs_syslog_level                          = undef,
  Optional[Stdlib::Absolutepath] $cvmfs_tracefile                     = undef,
  Optional[Stdlib::Absolutepath] $cvmfs_debuglog                      = undef,
  Optional[Integer] $cvmfs_max_ttl                                    = undef,
  Hash    $cvmfs_env_variables                                        = {},
  Hash $cvmfs_hash                                                    = {},
  Hash $cvmfs_domain_hash                                             = {},
  String[1] $cvmfs_version                                            = 'present',
  Boolean $repo_manage                                                = true,
  Integer $repo_priority                                              = 80,
  Boolean $repo_config_enabled                                        = false,
  Boolean $repo_testing_enabled                                       = false,
  Boolean $repo_future_enabled                                        = false,
  Optional[Stdlib::Httpurl] $repo_proxy                               = undef,
  Boolean $repo_gpgcheck                                              = true,
  Optional[Enum['yes','no']] $cvmfs_use_geoapi                        = undef,
  Optional[Enum['yes','no']] $cvmfs_follow_redirects                  = undef,
  Boolean $cvmfs_instrument_fuse                                      = false,
  Boolean $cvmfs_repo_list                                            = true,
  Optional[Variant[Integer[4,4],Integer[6,6]]] $cvmfs_ipfamily_prefer = undef,
  Optional[Integer] $cvmfs_dns_min_ttl                                = undef,
  Optional[Integer] $cvmfs_dns_max_ttl                                = undef,
  Optional[String] $cvmfs_alien_cache                                 = undef,
  Optional[Enum['yes','no']] $cvmfs_shared_cache                      = undef,
  Optional[String[1]] $cvmfs_repositories                             = undef,
  Boolean $cvmfs_fsck                                                 = false,
  Optional[String] $cvmfs_fsck_options                                = undef,
  Boolean $cvmfs_fsck_onreboot                                        = false,
  Optional[Enum['yes','no']] $cvmfs_cache_symlinks                    = undef,
  Optional[Enum['yes','no']] $cvmfs_cache_refcount                    = undef,
  Optional[Enum['yes','no']] $cvmfs_streaming_cache                   = undef,
  Optional[Integer[1]] $cvmfs_statfs_cache_timeout                    = undef,
  Optional[Enum['yes','no']] $cvmfs_world_readable                    = undef,
  Optional[Array[Integer[0],1]] $cvmfs_cpu_affinity                   = undef,
  Optional[Array[Integer[1],1]] $cvmfs_xattr_privileged_gids          = undef,
  Optional[Array[String[1],1]] $cvmfs_xattr_protected_xattrs          = undef,
  # Deprecated Parameters
  Optional[Boolean] $cvmfs_yum_manage_repo                                = undef,
  Optional[Stdlib::Httpurl] $cvmfs_yum                                    = undef,
  Optional[Stdlib::Httpurl] $cvmfs_yum_config                             = undef,
  Optional[Integer] $cvmfs_yum_priority                                   = undef,
  Optional[Integer[0,1]] $cvmfs_yum_config_enabled                        = undef,
  Optional[Stdlib::Httpurl] $cvmfs_yum_proxy                              = undef,
  Optional[Stdlib::Httpurl] $cvmfs_yum_testing                            = undef,
  Optional[Integer[0,1]] $cvmfs_yum_testing_enabled                       = undef,
  Optional[Integer[0,1]] $cvmfs_yum_gpgcheck                              = undef,
  Optional[Variant[Stdlib::Filesource,Stdlib::Httpurl]] $cvmfs_yum_gpgkey = undef,
  Optional[Variant[Enum['absent'], Array[String]]] $cvmfs_yum_includepkgs = undef,

) {
  # Deprecations
  {
    'cvmfs_yum_manage_repo'     => 'repo_manage',
    'cvmfs_yum'                 => 'repo_base',
    'cvmfs_yum_config'          => 'repo_base',
    'cvmfs_yum_testing'         => 'repo_base',
    'cvmfs_yum_priority'        => 'repo_priority',
    'cvmfs_yum_config_enabled'  => 'repo_config_enabled',
    'cvmfs_yum_testing_enabled' => 'repo_testing_enabled',
    'cvmfs_yum_proxy'           => 'repo_proxy',
    'cvmfs_yum_gpgcheck'        => 'repo_gpgcheck',
    'cvmfs_yum_gpgkey'          => 'repo_gpgkey',
    'cvmfs_yum_includepkgs'     => 'repo_includepkgs',
  }.each | $_deprecation, $_replacement | {
    if getvar($_deprecation) !~ Undef {
      fail("cvmfs parameter '${_deprecation}' is deprecated, Check how to use '${_replacement}' instead")
    }
  }

  if $repo_manage {
    case $facts['os']['family'] {
      'RedHat': {
        contain 'cvmfs::yum'
        Class['cvmfs::yum'] -> Class['cvmfs::install']
      }
      'Debian': {
        contain 'cvmfs::apt'
        Class['cvmfs::apt'] -> Package['cvmfs']

        Class['cvmfs::apt'] -> Class['cvmfs::install']
        # Needed since apt::update is only notified in apt::source, but not contained.
        Class['apt::update'] -> Package['cvmfs']
      }
      default: { fail('Only repositories for RedHat or Debian family can be managed') }
    }
  }

  contain 'cvmfs::install'
  contain 'cvmfs::config'
  contain 'cvmfs::service'
  Class['Cvmfs::Install'] -> Class['Cvmfs::Config'] ~> Class['Cvmfs::Service']

  if $cvmfs_fsck {
    include 'cvmfs::fsck'
  }

  # Finally allow the individual repositories or domains to be loaded from hiera.
  $cvmfs_hash.each |$_n, $_v| {
    cvmfs::mount { $_n:
      * => $_v,
    }
  }

  $cvmfs_domain_hash.each |$_n, $_v| {
    cvmfs::domain { $_n:
      * => $_v,
    }
  }
}
