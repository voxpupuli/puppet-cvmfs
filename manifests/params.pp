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

  # Manage the autofs service itself.
  $manage_autofs_service  = true

  # Use the puppet mount type to mount repositories
  $config_mount = false

  # Cvmfs_repo_list, should a CVMFS_REPOSITORIES entry be created
  # in default.local file
  $cvmfs_repo_list = true


  # These values are all destined for /etc/cvmfs/default.local
  # and provide defaults for all cvmfs repositories.
  $_cvmfs_quota_limit = hiera('cvmfs_quota_limit',false)
  if $_cvmfs_quota_limit {
    notify{'Setting cvmfs_quota_limit as a hiera variable is deprecated, use cvmfs::cvmfs_quota_limit now':}
    $cvmfs_quota_limit = $_cvmfs_quota_limit
  } else {
    $cvmfs_quota_limit = '1000'
  }

  # If cvmfs_quota_limit is set to 'auto' then cvmfs_quota_ratio will be used
  # to determine of the actual configured CVMFS_QUOTA_LIMIT
  # CVMFS_QUOTA_LIMIT = $cvmfs_quota_ratio * $::cvmfspartsize, the $::cvmfspartsize
  # comes from a custom fact, if $::cvmfspartsize doesn't exist use a sensible default value.
  $default_cvmfs_partsize = '10000'
  $_cvmfs_quota_ratio = hiera('cvmfs_quota_ratio',false)
  if $_cvmfs_quota_ratio {
    notify{'Setting cvmfs_quota_ratio as a hiera variable is deprecated, use cvmfs::cvmfs_quota_ratio now':}
    $cvmfs_quota_ratio      = $_cvmfs_quota_ratio
  } else {
    $cvmfs_quota_ratio  = '0.85'
  }

  $_cvmfs_http_proxy = hiera('cvmfs_http_proxy',false)
  if $_cvmfs_http_proxy {
    notify{'Setting cvmfs_http_proxy as a hiera variable is deprecated, use cvmfs::cvmfs_http_proxy now':}
    $cvmfs_http_proxy  = $_cvmfs_http_proxy
  } else {
    $cvmfs_http_proxy       = 'http://squid.example.org:3128'
  }
  $_cvmfs_server_url       = hiera('cvmfs_server_url',false)
  if $_cvmfs_server_url {
    notify{'Setting cvmfs_server_url as a hiera variable is deprecated, use cvmfs::cvmfs_server_url now':}
    $cvmfs_server_url       = $_cvmfs_server_url
  } else {
    $cvmfs_server_url       = ''
  }
  $default_cvmfs_cache_base  = '/var/lib/cvmfs'

  $cvmfs_memcache_size    = undef

  $_cvmfs_cache_base      = hiera('cvmfs_cache_base',false)
  if $_cvmfs_cache_base {
    notify{'Setting cvmfs_cache_base as a hiera variable is deprecated, use cvmfs::cvmfs_cache_base now':}
    $cvmfs_cache_base = $_cvmfs_cache_base
  } else {
    $cvmfs_cache_base = $default_cvmfs_cache_base
  }

  $_cvmfs_timeout          = hiera('cvmfs_timeout',false)
  if $_cvmfs_timeout {
    notify{'Setting cvmfs_timeout as a hiera variable is deprecated, use cvmfs::cvmfs_timeout now':}
    $cvmfs_timeout = $_cvmfs_timeout
  } else {
    $cvmfs_timeout = ''
  }

  $_cvmfs_timeout_direct          = hiera('cvmfs_timeout_direct',false)
  if $_cvmfs_timeout_direct {
    notify{'Setting cvmfs_timeout_direct as a hiera variable is deprecated, use cvmfs::cvmfs_timeout_direct now':}
    $cvmfs_timeout_direct = $_cvmfs_timeout_direct
  } else {
    $cvmfs_timeout_direct = ''
  }

  $_cvmfs_nfiles          = hiera('cvmfs_nfiles',false)
  if $_cvmfs_nfiles {
    notify{'Setting cvmfs_nfiles as a hiera variable is deprecated, use cvmfs::cvmfs_nfiles now':}
    $cvmfs_nfiles = $_cvmfs_nfiles
  } else {
    $cvmfs_nfiles = ''
  }

  $_cvmfs_public_key          = hiera('cvmfs_public_key',false)
  if $_cvmfs_public_key {
    notify{'Setting cvmfs_public_key as a hiera variable is deprecated, use cvmfs::cvmfs_public_key now':}
    $cvmfs_public_key = $_cvmfs_public_key
  } else {
    $cvmfs_public_key = ''
  }

  $_cvmfs_syslog_level          = hiera('cvmfs_syslog_level',false)
  if $_cvmfs_syslog_level {
    notify{'Setting cvmfs_syslog_level as a hiera variable is deprecated, use cvmfs::cvmfs_syslog_level now':}
    $cvmfs_syslog_level = $_cvmfs_syslog_level
  } else {
    $cvmfs_syslog_level = ''
  }

  $_cvmfs_tracefile          = hiera('cvmfs_tracefile',false)
  if $_cvmfs_tracefile {
    notify{'Setting cvmfs_tracefile as a hiera variable is deprecated, use cvmfs::cvmfs_tracefile now':}
    $cvmfs_tracefile = $_cvmfs_tracefile
  } else {
    $cvmfs_tracefile = undef
  }

  $_cvmfs_debuglog          = hiera('cvmfs_debuglog',false)
  if $_cvmfs_debuglog {
    notify{'Setting cvmfs_debuglog as a hiera variable is deprecated, use cvmfs::cvmfs_debuglog now':}
    $cvmfs_debuglog = $_cvmfs_debuglog
  } else {
    $cvmfs_debuglog = ''
  }

  $_cvmfs_max_ttl          = hiera('cvmfs_max_ttl',false)
  if $_cvmfs_max_ttl {
    notify{'Setting cvmfs_max_ttl as a hiera variable is deprecated, use cvmfs::cvmfs_max_ttl now':}
    $cvmfs_max_ttl = $_cvmfs_max_ttl
  } else {
    $cvmfs_max_ttl = ''
  }

  $cvmfs_mount_rw         = undef
  $_confused = hiera('cvmfs::mount',false)
  if $_confused {
    notify{'Setting cvmfs::mount as a hiera variable is deprecated, use cvmfs::cvmfs_hash now':}
    $cvmfs_hash = $_confused
  } else {
    $cvmfs_hash             = ''
  }
  $cvmfs_domain_hash      = undef
  $cvmfs_use_geoapi       = undef
  $cvmfs_env_variables    = undef
  $cvmfs_follow_redirects = undef
  $cvmfs_claim_ownership  = undef

  #The version of cvmfs to install, should be present and latest,
  # or an exact version number of the package.
  $cvmfs_version          = hiera('cvmfsversion','present')

  $cvmfs_yum_gpgcheck = '1'
  $cvmfs_yum_gpgkey   = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM'

  $_cvmfs_yum  = hiera('cvmfs_yum',false)
  if $_cvmfs_yum {
    notify{'Setting cvmfs_yum as a hiera variable is deprecated, use cvmfs::cvmfs_yum now':}
    $cvmfs_yum = $_cvmfs_yum
  } else {
    $cvmfs_yum = "http://cern.ch/cvmrepo/yum/cvmfs/EL/${::operatingsystemmajrelease}/${::architecture}"
  }

  $cvmfs_yum_config = "http://cern.ch/cvmrepo/yum/cvmfs-config/EL/${::operatingsystemmajrelease}/${::architecture}"
  $cvmfs_yum_config_enabled = '0'

  $_cvmfs_yum_testing      = hiera('cvmfs_yum_testing',false)
  if $_cvmfs_yum_testing {
    notify{'Setting cvmfs_yum_testing as a hiera variable is deprecated, use cvmfs::cvmfs_yum_testing now':}
    $cvmfs_yum_testing = $_cvmfs_yum_testing
  } else {
    $cvmfs_yum_testing = "http://cern.ch/cvmrepo/yum/cvmfs-testing/EL/${::operatingsystemmajrelease}/${::architecture}"
  }

  $_cvmfs_yum_testing_enabled      = hiera('cvmfs_yum_testing_enabled',false)
  if $_cvmfs_yum_testing_enabled {
    notify{'Setting cvmfs_yum_testing_enabled as a hiera variable is deprecated, use cvmfs::cvmfs_yum_testing_enabled now':}
    $cvmfs_yum_testing_enabled = $_cvmfs_yum_testing_enabled
  } else {
    $cvmfs_yum_testing_enabled = '0'
  }


  $cvmfs_yum_proxy        = undef

  $cvmfs_yum_manage_repo  = true

  # Only used is cvmfs::server is enabled.
  $_cvmfs_kernel_version      = hiera('cvmfs_kernel_version',false)
  if $_cvmfs_kernel_version {
    notify{'Setting cvmfs_kernel_version as a hiera variable is deprecated, use cvmfs::cvmfs_kernel_version now':}
    $cvmfs_kernel_version = $_cvmfs_kernel_version
  } else {
    $cvmfs_kernel_version = 'present'
  }

  $cvmfs_aufs2_version      = present
  $_cvmfs_yum_kernel      = hiera('cvmfs_yum_kernel',false)
  if $_cvmfs_yum_kernel {
    notify{'Setting cvmfs_yum_kernel as a hiera variable is deprecated, use cvmfs::cvmfs_yum_kernel now':}
    $cvmfs_yum_kernel = $_cvmfs_yum_kernel
  } else {
    $cvmfs_yum_kernel = "http://cern.ch/cvmrepo/yum/cvmfs-kernel/EL/${::operatingsystemmajrelease}/${::architecture}"
  }

  $_cvmfs_yum_kernel_enabled = hiera('cvmfs_yum_kernel_enabled',false)
  if $_cvmfs_yum_kernel_enabled {
    notify{'Setting cvmfs_yum_kernel_enabled as a hiera variable is deprecated, use cvmfs::cvmfs_yum_kernel_enabled now':}
    $cvmfs_yum_kernel_enabled = $_cvmfs_yum_kernel_enabled
  } else {
    $cvmfs_yum_kernel_enabled = '1'
  }

  $_cvmfs_sync_minute = hiera('cvmfs_sync_minute',false)
  if $_cvmfs_sync_minute {
    notify{'Setting cvmfs_sync_minute as a hiera variable is deprecated, use cvmfs::cvmfs_sync_minute now':}
    $cvmfs_sync_minute = $_cvmfs_sync_minute
  } else {
    $cvmfs_sync_minute = '*/15'
  }

}
