# @summary Installs and Configures CvmFS
#
# @see https://cvmfs.readthedocs.io/en/stable/apx-parameters.html CVMFS configuration parameters
#
# @example Simple Example For one Mount
#   class{"cvmfs":
#     cvmfs_http_proxy  => 'http://ca-proxy.example.org:3128',
#     cvmfs_quota_limit => 100
#   }
#   cvmfs::mount{'files.example.org:
#     cvmfs_server_url  => 'http://web.example.org/cvmfs/files.example.org',
#   }
#
# @example Mount a Domain
#   class{"cvmfs":
#     cvmfs_http_proxy  => 'http://ca-proxy.example.org:3128',
#     cvmfs_quota_limit => 100,
#   }
#   cvmfs::domain{'example.net'
#     cvmfs_server_url   => 'http://web.example.org/cvmfs/@fqrn@'
#   }
#
# @example Use Mount rather than AutoFS
#   class{'::cvmfs':
#     mount_method => 'mount',
#   }
#
# @param mount_method
#    The `autofs` will configure cvmfs to be mounted with autofs. The `mount` option will
#    use puppets mount type, currently adding a line to /etc/fstab. The *none* option
#    skips all mounting.  Note that migrating between for instance *autofs* and then *mount* is not supported.
# @param manage_autofs_service should the autofs service be maintained.
# @param cvmfs_quota_limit The cvmfs quota size in megabytes.
# @param cvmfs_quota_ratio
#   If set to ration, e.g '0.8' then 0.8 of the partition size
#   the cvmfs cache is on will be used. Setting this assumes you have
#   allocated a partition to cvmfs cache.
# @param cvmfs_http_proxy List of squid servers
# @param cvmfs_cache_base Location of the CVMFS cache base
# @param cvmfs_dns_min_ttl Minimum ttl of DNS lookups.
# @param cvmfs_dns_max_ttl Maximum ttl of DNS lookups.
# @param cvmfs_claim_ownership Whether the client claims ownership of files or not.
# @param cvmfs_uid_map Hash of UID pairs to map UIDs from catalogue to on the client.
# @param cvmfs_gid_map Hash of GID pairs to map GIDs from catalogue to on the client.
# @param cvmfs_memcache_size Size of the CernVM-FS meta-data memory cache in Megabyte.
# @param cvmfs_mount_rw Mount option to mount read-only or read/write.
# @param cvmfs_follow_redirects Sets CVMFS_FOLLOW_REDIRECTS to its value
# @param cvmfs_timeout cvmfs timeout setting.
# @param cvmfs_timeout_direct cvmfs timeout to direct connections, see params.pp for default.
# @param cvmfs_nfiles Number of open files, system setting, see params.pp for default.
# @param cvmfs_syslog_level Default is in params.pp
# @param cvmfs_tracefile Create a tracefile at this location.
# @param cvmfs_debuglog Create a debug log file at this location.
# @param cvmfs_max_ttl Max ttl, see params.pp for default.
# @param cvmfs_version Version of cvmfs to install , default is present.
# @param cvmfs_yum Yum repository URL for cvmfs.
# @param cvmfs_yum_priority Yum priority of repositories, defaults to 80.
# @param cvmfs_yum_proxy http proxy for cvmfs yum package repository
# @param cvmfs_yum_config  Yum repository URL for cvmfs site configs.
# @param cvmfs_yum_config_enabled  Defaults to false, set to true to enable.
# @param cvmfs_yum_testing Yum repository URL for cmvfs testing repository.
# @param cvmfs_yum_testing_enabled Defaults to false, should the testing repository be enabled.
# @param cvmfs_yum_gpgcheck  Defaults to true, set to false to disable GPG checking (Do Not Do This)
# @param cvmfs_yum_gpgkey  Set a custom GPG key for yum repos, you must deploy it yourself.
# @param cvmfs_yum_manage_repo Set to false to disable yum repositories management.
# @param cvmfs_use_geoapi Enable geoapi to find suitable proxies.
# @param cvmfs_repositories
#   By default undef and `CVMFS_REPOSITORIES` in `default.local` will be populated
#   automatically from what is explicitly mounted with `cvmfs::mount`. If this is
#   specified then`CVMFS_REPOSITORIES` list in `default.local` will be exactly managed with this variable.
#   e.g `cvmfs-config.cern.ch,atlas.cern.ch`
# @param cvmfs_hash
#   Rather than using cvmfs::mount defined type a hash of mounts can be sepecfied.
#   `cvmfs_hash {'myrepo' => {'cvmfs_server_url' => 'http://web.example.org/cvmfs/ams.example.org/}`
# @param cvmfs_env_variables
#  `$cvmfs_env_variables = {'CMS_LOCAL_SITE' => '<path to siteconf>'`
#   will produce `export CMS_LOCAL_SITE=<path to siteconf>`in the default.local file.
# @param default_cvmfs_partsize
# @param cvmfs_domain_hash Specify of a hash `cvmfs::domain` types.
# @param cvmfs_yum_includepkgs Specify an includepkgs to the yum repos to ignore other packages.
# @param cvmfs_instrument_fuse  Instrument Fuse
# @param cvmfs_repo_list Specify exactly the REPO_LIST in `defaults.local` overriding auto population.
# @param cvmfs_alien_cache Use an alien cache
# @param cvmfs_shared_cache Enable a shared cache
#
#
#
class cvmfs (
  Variant[Undef,String] $cvmfs_http_proxy,
  Enum['autofs','mount','none'] $mount_method                        = 'autofs',
  Boolean $manage_autofs_service                                     = true,
  Integer $default_cvmfs_partsize                                    = 10000,
  Variant[Enum['auto'],Integer] $cvmfs_quota_limit                   = 1000,
  Float   $cvmfs_quota_ratio                                         = 0.85,
  Stdlib::Absolutepath $cvmfs_cache_base                             = '/var/lib/cvmfs',
  Optional[Enum['yes','no']] $cvmfs_claim_ownership                  = undef,
  Optional[Hash[Variant[Integer,String], Integer, 1]] $cvmfs_uid_map = undef,
  Optional[Hash[Variant[Integer,String], Integer, 1]] $cvmfs_gid_map = undef,
  Optional[Enum['yes','no']] $cvmfs_mount_rw                         = undef,
  Optional[Integer] $cvmfs_memcache_size                             = undef,
  Optional[Integer] $cvmfs_timeout                                   = undef,
  Optional[Integer] $cvmfs_timeout_direct                            = undef,
  Optional[Integer] $cvmfs_nfiles                                    = undef,
  Optional[Integer[1,2]] $cvmfs_syslog_level                         = undef,
  Optional[Stdlib::Absolutepath] $cvmfs_tracefile                    = undef,
  Optional[Stdlib::Absolutepath] $cvmfs_debuglog                     = undef,
  Optional[Integer] $cvmfs_max_ttl                                   = undef,
  Hash    $cvmfs_env_variables                                       = {},
  Hash $cvmfs_hash                                                   = {},
  Hash $cvmfs_domain_hash                                            = {},
  String[1] $cvmfs_version                                           = 'present',
  Stdlib::Httpurl $cvmfs_yum                                         = "http://cern.ch/cvmrepo/yum/cvmfs/EL/${facts['os']['release']['major']}/${facts['os']['architecture']}",
  Stdlib::Httpurl $cvmfs_yum_config                                  = "http://cern.ch/cvmrepo/yum/cvmfs-config/EL/${facts['os']['release']['major']}/${facts['os']['architecture']}",
  Integer $cvmfs_yum_priority                                        = 80,
  Integer[0,1] $cvmfs_yum_config_enabled                             = 0,
  Optional[Stdlib::Httpurl] $cvmfs_yum_proxy                         = undef,
  Stdlib::Httpurl $cvmfs_yum_testing                                 = "http://cern.ch/cvmrepo/yum/cvmfs-testing/EL/${facts['os']['release']['major']}/${facts['os']['architecture']}",
  Integer[0,1] $cvmfs_yum_testing_enabled                            = 0,
  Integer[0,1] $cvmfs_yum_gpgcheck                                   = 1,
  Variant[Stdlib::Filesource,Stdlib::Httpurl] $cvmfs_yum_gpgkey      = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
  Variant[Enum['absent'], Array[String]] $cvmfs_yum_includepkgs      = ['cvmfs','cvmfs-keys','cvmfs-config-default'],
  Optional[Enum['yes','no']] $cvmfs_use_geoapi                       = undef,
  Optional[Enum['yes','no']] $cvmfs_follow_redirects                 = undef,
  Boolean $cvmfs_instrument_fuse                                     = false,
  Boolean $cvmfs_yum_manage_repo                                     = true,
  Boolean $cvmfs_repo_list                                           = true,
  Optional[Integer] $cvmfs_dns_min_ttl                               = undef,
  Optional[Integer] $cvmfs_dns_max_ttl                               = undef,
  Optional[String] $cvmfs_alien_cache                                = undef,
  Optional[Enum['yes','no']] $cvmfs_shared_cache                     = undef,
  Optional[String[1]] $cvmfs_repositories                            = undef,
) {
  contain 'cvmfs::install'
  contain 'cvmfs::config'
  contain 'cvmfs::service'
  Class['Cvmfs::Install'] -> Class['Cvmfs::Config'] ~> Class['Cvmfs::Service']

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
