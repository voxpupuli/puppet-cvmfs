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
  if ($facts['os']['name'] == 'Debian' and versioncmp($facts['os']['release']['major'],'12') <= 0 ) or
  ($facts['os']['name'] == 'Ubuntu' and versioncmp($facts['os']['release']['major'],'24.04') <= 0 ) {
    $_source_format = 'list'
    $_key           = {
      ensure  => refreshed,
      id      => 'FD80468D49B3B24C341741FC8CE0A76C497EA957',
      source  => $repo_gpgkey,
    }
    $_keyring       = undef
  } else {
    $_source_format = 'sources'
    $_key           = undef
    $_keyring       = '/etc/apt/keyrings/cernvm.gpg'

    apt::keyring { 'cernvm.gpg':
      source => $repo_gpgkey,
    }
  }

  Apt::Source {
    source_format  => $_source_format,
    allow_unsigned => ! $repo_gpgcheck,
    comment        => 'CernVM File System',
    location       => assert_type(String[1], $repo_base),
    key            => $_key,
    keyring        => $_keyring,
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
