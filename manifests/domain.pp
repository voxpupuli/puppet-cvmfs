# == Define: cvmfs::domain
define cvmfs::domain($cvmfs_quota_limit = undef,
  $cvmfs_server_url = undef,
  $cvmfs_http_proxy = undef,
  $cvmfs_timeout = undef,
  $cvmfs_timeout_direct = undef,
  $cvmfs_nfiles = undef,
  $cvmfs_public_key = undef,
  $cvmfs_force_singing = undef,
  $cvmfs_max_ttl = undef,
  $cvmfs_env_variables = undef,
  $cvmfs_use_geoapi = undef,
  $cvmfs_follow_redirects = undef,
  Optional[String] $cvmfs_external_fallback_proxy = undef,
  Optional[String] $cvmfs_external_http_proxy = undef,
  Optional[Integer] $cvmfs_external_timeout = undef,
  Optional[Integer] $cvmfs_external_timeout_direct = undef,
  Optional[String] $cvmfs_external_url = undef,
) {

  include ::cvmfs

  # In this case the repo is really a domain
  # but it's the same configuration file format
  # so we resuse the template.
  $repo = $name

  file{"/etc/cvmfs/domain.d/${repo}.local":
    ensure  =>  file,
    content => template('cvmfs/repo.local.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['cvmfs::install'],
    notify  => Class['cvmfs::service'],
  }
}

