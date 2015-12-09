#Class: cvmfs::zero::install , desingned
#to be included from instances of cvmfs::zero
class cvmfs::zero::service {
  service{'httpd':
    ensure => running,
    enable => true,
  }
}
