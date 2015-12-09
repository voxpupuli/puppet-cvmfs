# == Class: cvmfs::services
# Manages the cvmfs services. Optinally this also manages the autofs services
# as well.
#
# === Parameters
#
# === Authors
#
# Steve Traylen <steve.traylen@cern.ch>
#
# === Copyright
#
# Copyright 2012 CERN
#
class cvmfs::service (
  $manage_autofs_service = $cvmfs::manage_autofs_service
) inherits cvmfs {

  # CVMFS 2.0 had a SysV startup script to reload.
  # CVMFS 2.1 at least uses cvmfs_config.

  case $::cvmfsversion  {
    /^2\.0\..*/: {
      service{'cvmfs':
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        require    => [Class['cvmfs::config'],Class['cvmfs::install']],
      }
    }
    default: {
      exec{'Reloading cvmfs':
        command     => '/usr/bin/cvmfs_config reload',
        refreshonly => true,
      }
    }
  }
  if $manage_autofs_service {
    service{'autofs':
      ensure     => running,
      hasstatus  => true,
      hasrestart => true,
      enable     => true,
      require    => [Class['cvmfs::config'],Class['cvmfs::install']],
    }
  }
}

