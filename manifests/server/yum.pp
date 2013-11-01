# Class cvmfs::server::yum
class cvmfs::server::yum (
  $cvmfs_yum_kernel         = $cvmfs::params::cvmfs_yum_kernel,
  $cvmfs_yum_kernel_enabled = $cvmfs::params::cvmfs_yum_kernel_enabled,
  $major_release            = $cmvfs::params::major_release
) inherits cvmfs::params {

  class{'cvmfs::yum':}

  yumrepo{'cvmfs-kernel':
    descr       => "CVMFS yum kernel repository for el${major_release}",
    baseurl     => $cvmfs_yum_kernel,
    gpgcheck    => 1,
    gpgkey      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
    enabled     => $cvmfs_yum_kernel_enabled,
    includepkgs => 'kernel,aufs2-util,kernel-devel',
    priority    => 5,
    require     => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM']
  }
}

