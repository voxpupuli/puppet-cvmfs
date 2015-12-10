# == Define: cvmfs::mount
define cvmfs::mount($cvmfs_quota_limit = undef,
  $cvmfs_server_url = undef,
  $cvmfs_timeout = undef,
  $cvmfs_timeout_direct = undef,
  $cvmfs_nfiles = undef,
  $cvmfs_public_key = undef,
  $cvmfs_force_singing = undef,
  $cvmfs_max_ttl = undef,
  $cvmfs_env_variables = undef,
  $cvmfs_use_geoapi = undef,
  $cvmfs_repo_list = true,
  $cmvfs_mount_rw = undef,
  $cvmfs_follow_redirects = undef
) {

  include ::cvmfs
  # We only even attempt to configure cvmfs if the following
  # two facts are available and that requires that cvmfs
  # has been installed first potentially on the first puppet
  # run.
  if getvar(::cvmfsversion) and getvar(::cvmfspartsize) {

    $repo = $name

    file{"/etc/cvmfs/config.d/${repo}.local":
      ensure  =>  file,
      content => template('cvmfs/repo.local.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Class['cvmfs::install'],
      notify  => Class['cvmfs::service'],
    }
    if ! defined(Concat::Fragment['cvmfs_default_local_repo_start']) {
      concat::fragment{'cvmfs_default_local_repo_start':
        target  => '/etc/cvmfs/default.local',
        order   => 5,
        content => 'CVMFS_REPOSITORIES=\'',
      }
    }
    if $cvmfs_repo_list {
      concat::fragment{"cvmfs_default_local_${repo}":
        target  => '/etc/cvmfs/default.local',
        order   => 6,
        content => "${repo},",
      }
    }
    if ! defined(Concat::Fragment['cvmfs_default_local_repo_end']) {
      concat::fragment{'cvmfs_default_local_repo_end':
        target  => '/etc/cvmfs/default.local',
        order   => 7,
        content => "'\n\n",
      }
    }
  }
}

