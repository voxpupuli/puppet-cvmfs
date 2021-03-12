# == Define: cvmfs::domain
define cvmfs::domain (
  $domain = $name,
  $cvmfs_quota_limit = undef,
  $cvmfs_server_url = undef,
  $cvmfs_http_proxy = undef,
  $cvmfs_timeout = undef,
  $cvmfs_timeout_direct = undef,
  $cvmfs_nfiles = undef,
  $cvmfs_public_key = undef,
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
  include cvmfs

  # In this case the repo is really a domain
  # but it's the same configuration file format
  # so we resuse the template.

  file { "/etc/cvmfs/domain.d/${domain}.local":
    ensure  => file,
    content => epp('cvmfs/repo.local.epp', {
        'repo'                          => $domain,
        'cvmfs_quota_limit'             => $cvmfs_quota_limit,
        'cvmfs_server_url'              => $cvmfs_server_url,
        'cvmfs_http_proxy'              => $cvmfs_http_proxy,
        'cvmfs_timeout'                 => $cvmfs_timeout,
        'cvmfs_timeout_direct'          => $cvmfs_timeout_direct,
        'cvmfs_nfiles'                  => $cvmfs_nfiles,
        'cvmfs_public_key'              => $cvmfs_public_key,
        'cvmfs_max_ttl'                 => $cvmfs_max_ttl,
        'cvmfs_env_variables'           => $cvmfs_env_variables,
        'cvmfs_use_geoapi'              => $cvmfs_use_geoapi,
        'cvmfs_follow_redirects'        => $cvmfs_follow_redirects,
        'cvmfs_external_fallback_proxy' => $cvmfs_external_fallback_proxy,
        'cvmfs_external_timeout'        => $cvmfs_external_timeout,
        'cvmfs_external_http_proxy'     => $cvmfs_external_http_proxy,
        'cvmfs_external_timeout_direct' => $cvmfs_external_timeout_direct,
        'cvmfs_external_url'            => $cvmfs_external_url,
    }),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['cvmfs::install'],
    notify  => Class['cvmfs::service'],
  }
}
