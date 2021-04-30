# @summary Configure a a domain of cvmfs repositories
# @example Add the example.org domain
#  cvmfs::domain{'example.org':
#    cvmfs_server_url = 'http://example.org/cvmfs/@fqrn@',
#  }
#
# @param domain The domain of CvmFS repositories to mount
# @param cvmfs_quota_limit Per mount quota limit, not relavent to shared cache. Sets cvmfs_quota_limit
# @param cvmfs_server_url Stratum 1 list, typically `;` delimited. Sets CVMFS_SERVER_URL parameter.
# @param cvmfs_http_proxy List of http proxies to use. Sets CVMFS_PROXY_LIST parameter.
# @param cvmfs_timeout Sets CVMFS_HTTP_TIMEOUT parameter
# @param cvmfs_timeout_direct Sets CVMFS_HTTP_TIMEOUT_DIRECT
# @param cvmfs_nfiles Number of open files permitted on the OS. Sets CVMFS_NFILES
# @param cvmfs_max_ttl Maximum effective TTL in seconds for DNS queries of proxy server names. Sets CVMFS_MAX_TTL
# @param cvmfs_env_variables Sets per repo environments variables for magic links.
# @param cvmfs_use_geoapi Set CVMFS_MAX_GEOAPI
# @param cvmfs_follow_redirects Sets CVMFS_FOLLOW_REDIRECTS.
# @param cvmfs_external_fallback_proxy Sets CVMFS_EXTERNAL_FALLBACK_PROXY
# @param cvmfs_external_http_proxy Sets CVMFS_EXTERNAL_HTTP_PROXY
# @param cvmfs_external_timeout Sets CVMFS_EXTERNAL_TIMEOUT
# @param cvmfs_external_timeout_direct Sets CVMFS_EXTERNAL_TIMEOUT_DIRECT
# @param cvmfs_external_url Sets CVMFS_EXTERNAL_URL
# @param cvmfs_public_key Specify repository signing key
# @param cvmfs_keys_dir Specify repository directory with signing keys
#
define cvmfs::domain (
  Stdlib::Fqdn $domain                             = $name,
  Optional[Integer] $cvmfs_quota_limit             = undef,
  Optional[String[1]] $cvmfs_server_url            = undef,
  Optional[String[1]] $cvmfs_http_proxy            = undef,
  Optional[Integer] $cvmfs_timeout                 = undef,
  Optional[Integer] $cvmfs_timeout_direct          = undef,
  Optional[Integer] $cvmfs_nfiles                  = undef,
  Optional[String[1]] $cvmfs_public_key            = undef,
  Optional[Stdlib::Absolutepath] $cvmfs_keys_dir   = undef,
  Optional[Integer] $cvmfs_max_ttl                 = undef,
  Optional[Hash] $cvmfs_env_variables              = undef,
  Optional[Stdlib::Yes_no] $cvmfs_use_geoapi       = undef,
  Optional[Stdlib::Yes_no] $cvmfs_follow_redirects = undef,
  Optional[String] $cvmfs_external_fallback_proxy  = undef,
  Optional[String] $cvmfs_external_http_proxy      = undef,
  Optional[Integer] $cvmfs_external_timeout        = undef,
  Optional[Integer] $cvmfs_external_timeout_direct = undef,
  Optional[String] $cvmfs_external_url             = undef,
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
        'cvmfs_keys_dir'                => $cvmfs_keys_dir,
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
