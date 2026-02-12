# @summary Configure cvmfs apt repositories
# @api private
#
class cvmfs::apt (
  Variant[Stdlib::Httpurl,Array[Stdlib::Httpurl,1]] $repo_base          = $cvmfs::repo_base,
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
    $_keyring = undef
    # We already reject arrays of more than one element in init.pp
    $_location = Array($repo_base,true)[0] # Take first one for old format.
    $_release_cvmfs = "${facts['os']['distro']['codename']}-prod"
    $_release_testing = "${facts['os']['distro']['codename']}-testing"
    $_release_future = "${facts['os']['distro']['codename']}-future"
    $_repos = 'main'

    # These _ensure and _enabled parameters
    # https://github.com/puppetlabs/puppetlabs-apt/pull/1243
    # You cannot use "ensure"  => absent with format 'sources'.
    # You cannot use "enabled" => ... with format 'list'.
    #
    $_repo_testing_ensure = bool2str($repo_testing_enabled,'present','absent')
    $_repo_future_ensure = bool2str($repo_future_enabled,'present','absent')
    $_repo_testing_enabled = undef
    $_repo_future_enabled = undef
  } else { # deb822

    $_source_format = 'sources'
    $_location = Array($repo_base,true)
    $_release_cvmfs = ["${facts['os']['distro']['codename']}-prod"]
    $_release_testing = ["${facts['os']['distro']['codename']}-testing"]
    $_release_future = ["${facts['os']['distro']['codename']}-future"]
    $_repos = ['main']

    $_key = undef
    $_keyring = '/etc/apt/keyrings/cernvm.gpg'

    # see above
    $_repo_testing_ensure = 'present'
    $_repo_future_ensure = 'present'
    $_repo_testing_enabled = $repo_testing_enabled
    $_repo_future_enabled = $repo_future_enabled

    apt::keyring { 'cernvm.gpg':
      source => $repo_gpgkey,
      before => [Apt::Source['cvmfs'],Apt::Source['cvmfs-testing'],Apt::Source['cvmfs-future']],
    }
  }

  Apt::Source {
    comment        => 'CernVM File System',
    source_format  => $_source_format,
    allow_insecure => ! $repo_gpgcheck,
    location       => $_location,
    key            => $_key,
    keyring        => $_keyring,
    repos          => $_repos,
    notify_update  => true,
  }

  apt::source { 'cvmfs':
    ensure  => 'present',
    release => $_release_cvmfs,
  }

  apt::source { 'cvmfs-testing':
    ensure  => $_repo_testing_ensure,
    release => $_release_testing,
    enabled => $_repo_testing_enabled,
  }

  apt::source { 'cvmfs-future':
    ensure  => $_repo_future_ensure,
    release => $_release_future,
    enabled => $_repo_future_enabled,
  }
}
