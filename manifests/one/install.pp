# Class: cvmfs::one::install,
# included once from the cvmfs::one defined type.
class cvmfs::one::install (
  $cvmfs_version = $::cvmfs::params::cvmfs_version
) {
  class{'cvmfs::server::yum':}

  package{'cvmfs-server':
    ensure   => $cvmfs_version,
    require  => Yumrepo['cvmfs'],
  }
  package{'httpd':
    ensure => present
  }
}
