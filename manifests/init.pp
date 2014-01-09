# == Class: cvmfs
#
# Manages cvmfs clients using the automounter.
# Enable this class to provide new type cvmfs::mount
#
# === Examples
#
#  To mount two cvmfs volumes:
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

  # We only even attempt to configure cvmfs if the following
  # two facts are available and that requires that cvmfs
  # has been installed first potentially on the first puppet
  # run.
  if $::cvmfsversion and $::cvmfspartsize {
    class{'cvmfs::config':}
    class{'cvmfs::service':}
  } else {
    notify{'cvmfs has not been configured, one more puppet run required.':
      require => Class['cvmfs::install']
    }
  }
  # Finally allow the individual repositories to be loaded from hiera.
  if $cvmfs::params::cvmfs_hash {
    create_resources('cvmfs::mount', $cvmfs::params::cvmfs_hash)
  }
}
