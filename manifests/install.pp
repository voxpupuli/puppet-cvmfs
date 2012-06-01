# == Class: cvmfs::install
#
# Install cvmfs from a yum repository.
#
# === Parameters
#
# [*cvmfs_version*]
#   Is passed the cvmfs package instance to ensure the
#   cvmfs package with latest, present or an exact version.
#   See params.pp for default.
#
# === Authors
#
# Steve Traylen <steve.traylen@cern.ch>
#
# === Copyright
#
# Copyright 2012 CERN
#
class cvmfs::install (
    $cvmfs_version = $cvmfs::params::cvmfs_version
) inherits cvmfs::params {

   package{'cvmfs':
      ensure  => $cvmfs_version,
      require => Yumrepo['cvmfs'],
      notify  => [Class['cvmfs::config'],Class['cvmfs::service']]
   }

   $major = regsubst($::operatingsystemrelease,'^(\d+)\.\d+$','\1')
   osrepos::ai121yumrepo{'cvmfs':
      descr       => "CVMFS yum repository for el${major}",
      baseurl     => "http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs/EL/${major}/\$basearch",
      gpgcheck    => 1,
      gpgkey      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
      enabled     => 1,
      includepkgs => 'cvmfs,cvmfs-keys',
      priority    => 80,
      require     => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM']
   }
   # Copy out the gpg key once only ever.
   file{'/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM':
      ensure  => file,
      source  => 'puppet:///cvmfs/RPM-GPG-KEY-CernVM',
      replace => false,
      owner   => root,
      group   => root,
      mode    => '0644'
   }

}

