# Class cvmfs::server::yum
class cvmfs::zero::yum (
  Stdlib::Httpurl $cvmfs_yum_kernel       = "http://cern.ch/cvmrepo/yum/cvmfs-kernel/EL/${facts['os']['release']['major']}/${facts['os']['architecture']}",
  Integer[0,1] $cvmfs_yum_kernel_enabled  = 1,
  Stdlib::Httpurl $cvmfs_yum              = "http://cern.ch/cvmrepo/yum/cvmfs/EL/${facts['os']['release']['major']}/${facts['os']['architecture']}",
  Stdlib::Httpurl $cvmfs_yum_testing      = "http://cern.ch/cvmrepo/yum/cvmfs-testing/EL/${facts['os']['release']['major']}/${facts['os']['architecture']}",
  Integer[0,1] $cvmfs_yum_testing_enabled = 1,
) {

  yumrepo{'cvmfs':
    descr       => "CVMFS yum repository for el${::operatingsystemmajrelease}",
    baseurl     => $cvmfs_yum,
    gpgcheck    => 1,
    gpgkey      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
    enabled     => 1,
    includepkgs => 'cvmfs,cvmfs-keys,cvmfs-server,cvmfs-config*',
    priority    => 80,
    require     => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM'],
  }
  yumrepo{'cvmfs-testing':
    descr       => "CVMFS yum testing repository for el${::operatingsystemmajrelease}",
    baseurl     => $cvmfs_yum_testing,
    gpgcheck    => 1,
    gpgkey      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
    enabled     => $cvmfs_yum_testing_enabled,
    includepkgs => 'cvmfs,cvmfs-keys,cvmfs-server,cvmfs-config*',
    priority    => 80,
    require     => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM'],
  }

  # Copy out the gpg key once only ever.
  file{'/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM':
    ensure  => file,
    source  => 'puppet:///modules/cvmfs/RPM-GPG-KEY-CernVM',
    replace => false,
    owner   => root,
    group   => root,
    mode    => '0644',
  }



  yumrepo{'cvmfs-kernel':
    descr       => "CVMFS yum kernel repository for el${::operatingsystemmajrelease}",
    baseurl     => $cvmfs_yum_kernel,
    gpgcheck    => 1,
    gpgkey      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
    enabled     => $cvmfs_yum_kernel_enabled,
    includepkgs => 'kernel,aufs2-util,kernel-*,kmod-zfs-*,kmod-spl-*',
    priority    => 5,
    require     => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM'],
  }
}

