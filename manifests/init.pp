# == Class: cvmfs
#
# Manages cvmfs clients using the automounter.
# Enable this class to give provide new type cvmfs::mount
 
# === Examples
#
#  Too mount two cvmfs volumes.
#
#  class { cvmfs: }
#  cvmfs::mount{'atlas.example.org': cvmfs_quota => 5000}
#  cvmfs::mount{'cms.example.org': cvmfs_server_url => 'http://web.example.org/cms/' }
#
#  All defaults for repositories are maintained within params.pp 
#  and by default params.pp uses hiera to get values.
# 
#  See mount.pp for full list of parameters to 'cvmfs::mount' type.

# === Authors
#
# Author Name <steve.traylen@cern.ch>
#
# === Copyright
#
# Copyright 2012 CERN
#
class cvmfs (
) inherits cvmfs::params {

   Class['concat::setup'] -> Class['cvmfs']

   class{'cvmfs::install':}
   class{'cvmfs::config':}
   class{'cvmfs::service':}

  # Finally allow the individual repositories to be loaded from hiera.
  $cvmfshash = hiera('cvmfs::mount',undef)
  create_resources('cvmfs::mount',$cvmfshash)



}
