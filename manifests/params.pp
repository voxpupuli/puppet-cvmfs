#Class: cvmfs::params
class cvmfs::params {

  # For now just check os and exit if it untested.
  if $::osfamily == 'RedHat' and $::operatingsystem == 'Fedora' {
    fail('This cvmfs module has not been verified under fedora.')
  } elsif $::osfamily != 'RedHat' {
    fail('This cvmfs module has not been verified under osfamily other than RedHat')
  }

  # Specify a mount method, be default it is autofs
  # Permitted to be 'autofs' or 'mount' or 'none currently.
  $mount_method = 'autofs'

  # Now deprecated 
  $config_automaster      = hiera('cvmfs_config_automaster',true)

  # Manage the autofs service itself.
  $manage_autofs_service  = $config_automaster

  # Use the puppet mount type to mount repositories
  $config_mount = false

  # Cvmfs_repo_list, should a CVMFS_REPOSITORIES entry be created
  # in default.local file
  $cvmfs_repo_list = true


  # These values are all destined for /etc/cvmfs/default.local
  # and provide defaults for all cvmfs repositories.
  $cvmfs_quota_limit      = hiera('cvmfs_quota_limit','1000')

  # If cvmfs_quota_limit is set to 'auto' then cvmfs_quota_ratio will be used
  # to determine of the actual configured CVMFS_QUOTA_LIMIT
  # CVMFS_QUOTA_LIMIT = $cvmfs_quota_ratio * $::cvmfspartsize, the $::cvmfspartsize
  # comes from a custom fact, if $::cvmfspartsize doesn't exist use a sensible default value.
  $default_cvmfs_partsize = '10000'
  $cvmfs_quota_ratio      = hiera('cvmfs_quota_ratio','0.85')

  $cvmfs_http_proxy       = hiera('cvmfs_http_proxy','http://squid.example.org:3128')
  $cvmfs_server_url       = hiera('cvmfs_server_url','')
  $default_cvmfs_cache_base  = '/var/lib/cvmfs'

  $cvmfs_memcache_size    = undef
  $cvmfs_cache_base       = hiera('cvmfs_cache_base',$default_cvmfs_cache_base)
  $cvmfs_timeout          = hiera('cvmfs_timeout','')
  $cvmfs_timeout_direct   = hiera('cvmfs_timeout','')
  $cvmfs_nfiles           = hiera('cvmfs_nfiles','')
  $cvmfs_public_key       = hiera('cvmfs_public_key','')
  $cvmfs_force_signing    = hiera('cvmfs_force_signing','yes')
  $cvmfs_syslog_level     = hiera('cvmfs_syslog_level','')
  $cvmfs_tracefile        = hiera('cvmfs_tracefile','')
  $cvmfs_debuglog         = hiera('cvmfs_debuglog','')
  $cvmfs_max_ttl          = hiera('cvmfs_max_ttl','')
  $cvmfs_mount_rw         = undef
  $cvmfs_hash             = hiera('cvmfs::mount','')
  $cvmfs_domain_hash      = undef
  $cvmfs_use_geoapi       = undef
  $cvmfs_env_variables    = undef
  $cvmfs_follow_redirects = undef

  #The version of cvmfs to install, should be present and latest,
  # or an exact version number of the package.
  $cvmfs_version          = hiera('cvmfsversion','present')

  $cvmfs_yum_gpgcheck = '1'
  $cvmfs_yum_gpgkey   = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM'

  $cvmfs_yum              = hiera('cvmfs_yum',"http://cern.ch/cvmrepo/yum/cvmfs/EL/${::operatingsystemmajrelease}/${::architecture}")

  $cvmfs_yum_config = "http://cern.ch/cvmrepo/yum/cvmfs-config/EL/${::operatingsystemmajrelease}/${::architecture}"
  $cvmfs_yum_config_enabled = '0'

  $cvmfs_yum_testing      = hiera('cvmfs_yum_testing',"http://cern.ch/cvmrepo/yum/cvmfs-testing/EL/${::operatingsystemmajrelease}/${::architecture}")
  $cvmfs_yum_testing_enabled = hiera('cvmfs_yum_testing_enabled','0')

  $cvmfs_yum_proxy        = undef

  $cvmfs_yum_manage_repo  = true

  # Only used is cvmfs::server is enabled.
  $cvmfs_kernel_version     = hiera('cvmfs_kernel_version','present')
  $cvmfs_aufs2_version      = present
  $cvmfs_yum_kernel         = hiera('cvmfs_yum_kernel',"http://cern.ch/cvmrepo/yum/cvmfs-kernel/EL/${::operatingsystemmajrelease}/${::architecture}")
  $cvmfs_yum_kernel_enabled = hiera('cvmfs_yum_kernel_enabled','1')

  $cvmfs_sync_minute        = hiera('cvmfs_sync_minute','*/15')

}
