# == Class: cvmfs
class cvmfs (
  $config_automaster          = $cvmfs::params::config_automaster,
  $manage_autofs_service      = $cvmfs::params::manage_autofs_service,
  $cvmfs_quota_limit          = $cvmfs::params::cvmfs_quota_limit,
  $cvmfs_quota_ratio          = $cvmfs::params::cvmfs_quota_ratio,
  $cvmfs_http_proxy           = $cvmfs::params::cvmfs_http_proxy,
  $cvmfs_cache_base           = $cvmfs::params::cvmfs_cache_base,
  $cvmfs_mount_rw             = $cvmfs::params::cvmfs_mount_rw,
  $cvmfs_timeout              = $cvmfs::params::cvmfs_timeout,
  $cvmfs_timeout_direct       = $cvmfs::params::cvmfs_timeout_direct,
  $cvmfs_nfiles               = $cvmfs::params::cvmfs_nfiles,
  $cvmfs_force_signing        = $cvmfs::params::cvmfs_force_signing,
  $cvmfs_syslog_level         = $cvmfs::params::cvmfs_syslog_level,
  $cvmfs_tracefile            = $cvmfs::params::cvmfs_tracefile,
  $cvmfs_debuglog             = $cvmfs::params::cvmfs_debuglog,
  $cvmfs_max_ttl              = $cvmfs::params::cvmfs_max_ttl,
  $cvmfs_env_variables        = $cvmfs::params::cvmfs_env_variables,
  $cvmfs_hash                 = $cvmfs::params::cvmfs_hash,
  $cvmfs_domain_hash          = $cvmfs::params::cvmfs_domain_hash,
  $cvmfs_version              = $cvmfs::params::cvmfs_version,
  $cvmfs_yum                  = $cvmfs::params::cvmfs_yum,
  $cvmfs_yum_config           = $cvmfs::params::cvmfs_yum_config,
  $cvmfs_yum_config_enabled   = $cvmfs::params::cvmfs_yum_config_enabled,
  $cvmfs_yum_proxy            = $cvmfs::params::cvmfs_yum_proxy,
  $cvmfs_yum_testing          = $cvmfs::params::cvmfs_yum_testing,
  $cvmfs_yum_testing_enabled = $cvmfs::params::cvmfs_yum_testing_enabled,
  $cvmfs_yum_gpgcheck         = $cvmfs::params::cvmfs_yum_gpgcheck,
  $cvmfs_yum_gpgkey           = $cvmfs::params::cvmfs_yum_gpgkey,
  $cvmfs_use_geoapi           = $cvmfs::params::cvmfs_use_geoapi,
  $cvmfs_server_url           = $cvmfs::params::cvmfs_server_url,
  $cvmfs_follow_redirects     = $cvmfs::params::cvmfs_follow_redirects,
  $cvmfs_yum_manage_repo      = $cvmfs::params::cvmfs_yum_manage_repo,
) inherits cvmfs::params {

  if $cvmfs_server_url != ''  {
    warning('The $cvmfs_server_url to cvmfs is deprecated, please set this value per mount or per domain.')
  }

  class{'::cvmfs::install':}

  # We only even attempt to configure cvmfs if the following
  # two facts are available and that requires that cvmfs
  # has been installed first potentially on the first puppet
  # run.
  if getvar(::cvmfsversion) and getvar(::cvmfspartsize) {
    class{'::cvmfs::config':}
    class{'::cvmfs::service':}
  } else {
    notify{'cvmfs has not been configured, one more puppet run required.':
      require => Class['cvmfs::install'],
    }
    warning('cvmfs has not been configured, one more puppet run required.')
  }
  # Finally allow the individual repositories to be loaded from hiera.
  if is_hash($cvmfs_hash) {
    create_resources('cvmfs::mount', $cvmfs_hash)
  }
  if is_hash($cvmfs_domain_hash) {
    create_resources('cvmfs::domain', $cvmfs_domain_hash)
  }

}
