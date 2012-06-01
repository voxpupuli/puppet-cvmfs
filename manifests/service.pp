# == Class: cvmfs::services
# Manages the cvmfs services. Optinally this also manages the autofs services
# as well.
#
# === Parameters
#
# [*config_automaster*]
#   This module can configure autofs in addition to cvmfs but at
#   some locations this may not be sensible. Set to 'false'  to
#   stop this module configuring autofs.
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
   $config_automaster = $cvmfs::params::config_automaster
) inherits cvmfs::params {
  service{'cvmfs':
             ensure => running,
             hasstatus => true,
             hasrestart => true,
             enable => true,
             require => [Class['cvmfs::config'],Class['cvmfs::install']]
  }
  service{'autofs':
             ensure => running,
             hasstatus => true,
             hasrestart => true,
             enable => true,
             require => [Class['cvmfs::config'],Class['cvmfs::install']]
  }

}

