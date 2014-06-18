# Class cvmfs::server::yum
class cvmfs::server::yum (
  $cvmfs_yum_kernel         = $cvmfs::params::cvmfs_yum_kernel,
  $cvmfs_yum_kernel_enabled = $cvmfs::params::cvmfs_yum_kernel_enabled,
  $major_release            = $cmvfs::params::major_release
) inherits cvmfs::server {

  $major = $cvmfs::params::major_release
  yumrepo{'cvmfs':
    descr       => "CVMFS yum repository for el${major}",
    baseurl     => $cvmfs_yum,
    gpgcheck    => 1,
    gpgkey      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
    enabled     => 1,
    includepkgs => 'cvmfs,cvmfs-keys,cvmfs-server',
    priority    => 80,
    require     => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM']
  }
  yumrepo{'cvmfs-testing':
    descr       => "CVMFS yum testing repository for el${major}",
    baseurl     => $cvmfs_yum_testing,
    gpgcheck    => 1,
    gpgkey      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
    enabled     => $cvmfs_yum_testing_enabled,
    includepkgs => 'cvmfs,cvmfs-keys,cvmfs-server',
    priority    => 80,
    require     => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM']
  }

  # Copy out the gpg key once only ever.
  file{'/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM':
    ensure  => file,
    source  => 'puppet:///modules/cvmfs/RPM-GPG-KEY-CernVM',
    replace => false,
    owner   => root,
    group   => root,
    mode    => '0644'
  }



  yumrepo{'cvmfs-kernel':
    descr       => "CVMFS yum kernel repository for el${major_release}",
    baseurl     => $cvmfs_yum_kernel,
    gpgcheck    => 1,
    gpgkey      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
    enabled     => $cvmfs_yum_kernel_enabled,
    includepkgs => 'kernel,aufs2-util,kernel-*',
    priority    => 5,
    require     => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM']
  }
}

