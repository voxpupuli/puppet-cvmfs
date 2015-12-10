#Class: cvmfs::params
class cvmfs::params {

  # For now just check os and cvmfsversion and exit if it untested.
  # in time we can different parameters for each of these conditions.
  if $::osfamily == 'RedHat' and $::operatingsystem == 'Fedora' {
    fail('This cvmfs module has not been verified under fedora.')
  } elsif $::osfamily != 'RedHat' {
    fail('This cvmfs module has not been verified under osfamily other than RedHat')
  }

  # This cvmfs module will also configure autofs as well for use
  # by cvmfs. If you are managing autofs elsewhere set to false.
  # This being the string 'true' and not boolean true is a hiera bug.
  $config_automaster      = hiera('cvmfs_config_automaster',true)
  $manage_autofs_service  = $config_automaster


  # These values are all destined for /etc/cvmfs/default.local
  # and provide defaults for all cvmfs repositories.
  $cvmfs_quota_limit      = hiera('cvmfs_quota_limit','1000')

  # If cvmfs_quota_limit is set to 'auto' then cvmfs_quota_ratio will be used
  # to determine of the actual configured CVMFS_QUOTA_LIMIT
  # CVMFS_QUOTA_LIMIT = $cvmfs_quota_ratio * $::cvmfspartsize, the $::cvmfspartsize
  # comes from a custom fact.
  $cvmfs_quota_ratio  = hiera('cvmfs_quota_ratio','0.85')

  $cvmfs_http_proxy       = hiera('cvmfs_http_proxy','http://squid.example.org:3128')
  $cvmfs_server_url       = hiera('cvmfs_server_url','')
  case getvar(::cvmfsversion) {
    /^2\.0\.*/: {
      $default_cvmfs_cache_base  = '/var/cache/cvmfs2'
    }
    default: {
      $default_cvmfs_cache_base  = '/var/lib/cvmfs'
    }
  }

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

  # The version of cvmfs to install, should be present and latest,
  # or an exact version number of the package.
  $cvmfs_version          = hiera('cvmfsversion','present')

  $cvmfs_yum_gpgcheck = '1'
  $cvmfs_yum_gpgkey   = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM'

  $cvmfs_yum              = hiera('cvmfs_yum',"http://cern.ch/cvmrepo/yum/cvmfs/EL/${::operatingsystemmajrelease}/${::architecture}")

  $cvmfs_yum_config = "http://cern.ch/cvmrepo/yum/cvmfs-config/EL/${::operatingsystemmajrelease}/${::architecture}"
  $cvmfs_yum_config_enabled = '0'

  $cvmfs_yum_testing      = hiera('cvmfs_yum_testing',"http://cern.ch/cvmrepo/yum/cvmfs-testing/EL/${::operatingsystemmajrelease}/${::architecture}")
  $cvmfs_yum_testing_enabled = hiera('cvmfs_yum_testing_enabled','0')

  $cvmfs_yum_proxy        = hiera('cvmfs_yum_proxy','_none_')

  # Only used is cvmfs::server is enabled.
  $cvmfs_kernel_version     = hiera('cvmfs_kernel_version','present')
  $cvmfs_yum_kernel         = hiera('cvmfs_yum_kernel',"http://cern.ch/cvmrepo/yum/cvmfs-kernel/EL/${::operatingsystemmajrelease}/${::architecture}")
  $cvmfs_yum_kernel_enabled = hiera('cvmfs_yum_kernel_enabled','1')

}
