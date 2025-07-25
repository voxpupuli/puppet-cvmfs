# @summary Configure cvmfs apt repositories
# @api private
#
class cvmfs::apt (
  Stdlib::Httpurl $repo_base                                            = $cvmfs::repo_base,
  Stdlib::Httpurl $repo_gpgkey                                          = $cvmfs::repo_gpgkey,
  Boolean $repo_testing_enabled                                         = $cvmfs::repo_testing_enabled,
  Boolean $repo_future_enabled                                          = $cvmfs::repo_future_enabled,
  Optional[Stdlib::Httpurl] $repo_proxy                                 = $cvmfs::repo_proxy,
  Boolean $repo_gpgcheck                                                = $cvmfs::repo_gpgcheck,

) {
  Apt::Source {
    allow_unsigned => ! $repo_gpgcheck,
    comment        => 'CernVM File System',
    location       => $repo_base,
    key            => {
      ensure  => refreshed,
      id      => '70B9890488208E315ED45208230D389D8AE45CE7',
      source  => $repo_gpgkey,
    },
    repos          => 'main',
    notify_update  => true,
  }

  apt::source { 'cvmfs':
    ensure  => 'present',
    release => "${facts['os']['distro']['codename']}-prod",
  }

  apt::source { 'cvmfs-testing':
    ensure  => bool2str($repo_testing_enabled,'present','absent'),
    release => "${facts['os']['distro']['codename']}-testing",
  }
  apt::source { 'cvmfs-future':
    ensure  => bool2str($repo_future_enabled,'present','absent'),
    release => "${facts['os']['distro']['codename']}-future",
  }
}
