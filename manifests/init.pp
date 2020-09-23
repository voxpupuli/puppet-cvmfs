# == Class: cvmfs
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
  Stdlib::Httpurl $cvmfs_yum                                         = "http://cern.ch/cvmrepo/yum/cvmfs/EL/${::operatingsystemmajrelease}/${::architecture}",
  Stdlib::Httpurl $cvmfs_yum_config                                  = "http://cern.ch/cvmrepo/yum/cvmfs-config/EL/${::operatingsystemmajrelease}/${::architecture}",
  Integer $cvmfs_yum_priority                                        = 80,
  Integer[0,1] $cvmfs_yum_config_enabled                             = 0,
  Optional[Stdlib::Httpurl] $cvmfs_yum_proxy                         = undef,
  Stdlib::Httpurl $cvmfs_yum_testing                                 = "http://cern.ch/cvmrepo/yum/cvmfs-testing/EL/${::operatingsystemmajrelease}/${::architecture}",
  Integer[0,1] $cvmfs_yum_testing_enabled                            = 0,
  Integer[0,1] $cvmfs_yum_gpgcheck                                   = 1,
  Variant[Stdlib::Filesource,Stdlib::Httpurl] $cvmfs_yum_gpgkey      = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
  Variant[Enum['absent'], Array[String]] $cvmfs_yum_includepkgs      = ['cvmfs','cvmfs-keys','cvmfs-server','cvmfs-config-default'],
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

  # Finally allow the individual repositories to be loaded from hiera.
  create_resources('cvmfs::mount', $cvmfs_hash)
  create_resources('cvmfs::domain', $cvmfs_domain_hash)

}
