# @summary Installs and Configures CvmFS
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
# @param mount_method
#    The `autofs` option will configure cvmfs to be mounted with autofs. The `mount` option will
#    use puppet's mount type, currently adding a line to /etc/fstab. The *none* option
#    skips all mounting.  Note that migrating between for instance *autofs* and then *mount* is not supported.
# @param manage_autofs_service should the autofs service be maintained.
# @param cvmfs_quota_limit The cvmfs quota size in megabytes.
# @param cvmfs_quota_ratio
#   If set , e.g '0.8', then 0.8 of the partition size
#   the cvmfs cache is on will be used. Setting this assumes you have
#   pre-allocated a partition to the cvmfs cache or else it makes little sense.
# @param cvmfs_http_proxy List of squid servers, e.g `http://squid1.example.org;http;//squid2.example.org`
# @param cvmfs_cache_base Location of the CVMFS cache base
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
# @param repo_base URL containting stable, testing and config apt or yum repositories. Default in hiera data.
# @param repo_includepkgs Specify an includepkgs to the yum repos to ignore other packages.
# @param repo_priority Yum priority of repositories
# @param repo_proxy http proxy for cvmfs yum package repository
# @param repo_config_enabled Should the config yum repository be enabled
# @param repo_testing_enabled Should the testing repository be enabled.
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
  Stdlib::Httpurl $repo_gpgkey,
  Variant[Undef,String] $cvmfs_http_proxy,
  Enum['autofs','mount','none'] $mount_method                         = 'autofs',
  Boolean $manage_autofs_service                                      = true,
  Integer $default_cvmfs_partsize                                     = 10000,
  Variant[Enum['auto'],Integer] $cvmfs_quota_limit                    = 1000,
  Float   $cvmfs_quota_ratio                                          = 0.85,
  Stdlib::Absolutepath $cvmfs_cache_base                              = '/var/lib/cvmfs',
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
  Optional[Stdlib::Httpurl] $repo_proxy                               = undef,
  Boolean $repo_gpgcheck                                              = true,
  Optional[Variant[Enum['absent'], Array[String[1]]]] $repo_includepkgs,
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
