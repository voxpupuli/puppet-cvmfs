# Class: cvmfs::one::install,
# included once from the cvmfs::one defined type.
class cvmfs::one::install (
  $cvmfs_version = $::cvmfs::params::cvmfs_version
) {
  class{'::cvmfs::server::yum':}

  package{'cvmfs-server':
    ensure  => $cvmfs_version,
    require => Yumrepo['cvmfs'],
  }

  # Don't conflict if already declared
  ensure_packages(['httpd','mod_wsgi'], { ensure => present,})
}
