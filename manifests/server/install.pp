# Class - cvmfs::server::install
class cvmfs::server::install (
  # lint:ignore:parameter_documentation
  String $cvmfs_version        = 'present',
  String $cvmfs_kernel_version = 'present',
  String $cvmfs_aufs2_version  = 'present',
  # lint:endignore
) {
  class { 'cvmfs::server::yum': }

  package { ['cvmfs-server','cvmfs']:
    ensure  => $cvmfs_version,
    require => Yumrepo['cvmfs'],
  }
  package { 'kernel':
    ensure  => $cvmfs_kernel_version,
    require => Yumrepo['cvmfs-kernel'],
  }
  package { 'aufs2-util':
    ensure => $cvmfs_aufs2_version,
  }
  ensure_packages('httpd', { ensure => present, })
}
