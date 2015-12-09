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
  $cvmfs_yum_testing = $cvmfs::cvmfs_yum_testing,
  $cvmfs_yum = $cvmfs::cvmfs_yum,
  $cvmfs_yum_config = $cvmfs::cvmfs_yum_config,
  $cvmfs_yum_config_enabled = $cvmfs::cvmfs_yum_config_enabled,
  $cvmfs_yum_testing_enabled  = $cvmfs::cvmfs_yum_testing_enabled,
  $cvmfs_yum_proxy = $cvmfs::cvmfs_yum_proxy,
  $cvmfs_yum_gpgcheck = $cvmfs::cvmfs_yum_gpgcheck,
  $cvmfs_yum_gpgkey = $cvmfs::cvmfs_yum_gpgkey,
)  inherits cvmfs {

  yumrepo{'cvmfs':
    descr       => "CVMFS yum repository for el${::operatingsystemmajrelease}",
    baseurl     => $cvmfs_yum,
    gpgcheck    => $cvmfs_yum_gpgcheck,
    gpgkey      => $cvmfs_yum_gpgkey,
    enabled     => 1,
    includepkgs => 'cvmfs,cvmfs-keys,cvmfs-server,cvmfs-config-default',
    priority    => 80,
    require     => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM'],
    proxy       => $cvmfs_yum_proxy,
  }
  yumrepo{'cvmfs-testing':
    descr       => "CVMFS yum testing repository for el${::operatingsystemmajrelease}",
    baseurl     => $cvmfs_yum_testing,
    gpgcheck    => $cvmfs_yum_gpgcheck,
    gpgkey      => $cvmfs_yum_gpgkey,
    enabled     => $cvmfs_yum_testing_enabled,
    includepkgs => 'cvmfs,cvmfs-keys,cvmfs-server,cvmfs-config-default',
    priority    => 80,
    require     => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM'],
    proxy       => $cvmfs_yum_proxy,
  }
  yumrepo{'cvmfs-config':
    descr    => "CVMFS config yum repository for el${::operatingsystemmajrelease}",
    baseurl  => $cvmfs_yum_config,
    gpgcheck => $cvmfs_yum_gpgcheck,
    gpgkey   => $cvmfs_yum_gpgkey,
    enabled  => $cvmfs_yum_config_enabled,
    priority => 80,
    require  => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM'],
    proxy    => $cvmfs_yum_proxy,
  }

  #  Copy out the gpg key once only ever.
  file{'/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM':
    ensure  => file,
    source  => 'puppet:///modules/cvmfs/RPM-GPG-KEY-CernVM',
    replace => false,
    owner   => root,
    group   => root,
    mode    => '0644',
  }
}

