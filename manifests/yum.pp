# == Class: cvmfs::yum
#
# Configures cvmfs from a yum repository.
#
# === Parameters
# === Authors
#
# Steve Traylen <steve.traylen@cern.ch>
#
# === Copyright
#
# Copyright 2012 CERN
#
class cvmfs::yum (
  $cvmfs_yum = $cvmfs::params::cvmfs_yum,
  $cvmfs_yum_testing = $cvmfs::params::cvmfs_yum_testing,
  $cvmfs_yum_testing_enabled = $cvmfs::params::cvmfs_yum_testing_enabled,
) inherits cvmfs::params {

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
}

