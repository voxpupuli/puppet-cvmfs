# == Define: cvmfs::domain
define cvmfs::domain($cvmfs_quota_limit = undef,
  $cvmfs_server_url = undef,
  $cvmfs_timeout = undef,
  $cvmfs_timeout_direct = undef,
  $cvmfs_nfiles = undef,
  $cvmfs_public_key = undef,
  $cvmfs_force_singing = undef,
  $cvmfs_max_ttl = undef,
  $cvmfs_env_variables = undef,
  $cvmfs_use_geoapi = undef,
  $cvmfs_follow_redirects = undef
) {

  include ::cvmfs
  # We only even attempt to configure cvmfs if the following
  # two facts are available and that requires that cvmfs
  # has been installed first potentially on the first puppet
  # run.
  if getvar(::cvmfsversion) and getvar(::cvmfspartsize) {

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
}

