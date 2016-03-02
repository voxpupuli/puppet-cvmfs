# Class - cvmfs::server::install
class cvmfs::server::install (
  $cvmfs_version        = $cvmfs::params::cvmfs_version,
  $cvmfs_kernel_version = $cvmfs::params::cvmfs_kernel_version,
  $cvmfs_aufs2_version  = $cvmfs::params::cvmfs_aufs2_version
) inherits cvmfs::params {

  class{'::cvmfs::server::yum':}

  package{['cvmfs-server','cvmfs']:
    ensure  => $cvmfs_version,
    require => Yumrepo['cvmfs'],
  }
  package{'kernel':
    ensure  => $cvmfs_kernel_version,
    require => Yumrepo['cvmfs-kernel'],
  }
  package{'aufs2-util':
    ensure => $cvmfs_aufs2_version,
  }
  ensure_packages('httpd', { ensure => present, })
}



