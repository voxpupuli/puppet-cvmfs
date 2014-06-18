# == Class: cvmfs
#
# Manages cvmfs clients using the automounter.
# Enable this class to provide new type cvmfs::mount
#
# === Parameters

# [*config_automounter*]
#   boolean defaults to true and configures the automounter for cvmfs.
#
# [*cvmfs_quota_limit*]
#   The cvmfs quota size in megabytes. See params.pp for default.
#
# [*cvmfs_quota_ratio*]
#   If set to ration, e.g '0.8' then 0.8 of the partition size
#   the cvmfs cache is on will be used. Setting this assumes
#   you have allocated a partition to cvmfs cache.
#
# [*cvmfs_http_proxy*]
#   List of squid servers, see params.pp for default.
#
# [*cvmfs_timeout*]
#   cvmfs timeout setting, see params.pp for default.
#
# [*cvmfs_timeout_direct*]
#   cvmfs timeout to direct connections, see params.pp for default.
#
# [*cvmfs_nfiles*]
#   Number of open files, system setting, see params.pp for default.
#
# [*cvmfs_force_signing*]
#   Boolean defaults to true, repositories must be signed.
#
# [cvmfs_syslog_level*]
#   Default is in params.pp
#
# [*cvmfs_tracefile*]
#   Create a tracefile at this location.
#
# [*cvmfs_debuglog*]
#   Create a debug log file at this location.
#
# [*cvmfs_max_ttl*]
#   Max ttl, see params.pp for default.
# [*cvmfs_hash*]
#   Rather than using cvmfs::mount defined type a hash of mounts can be sepecfied.
#   cvmfs_hash => {'myrepo' => {'cvmfs_server_url' => 'http://web.example.org/cvmfs/ams.example.org/}
#
# [*cvmfs_version*]
#   Version of cvmfs to install , default is present.
#
# [*cvmfs_yum*]
#   Yum repository URL for cvmfs.
#
# [*cvmfs_yum_testing*]
#   Yum repository URL for cmvfs testing repository.
#
# [*cvmfs_yum_testing_enabled*]
#    Defaults to false, should the testing repository be enabled.
#
# === Examples
#
#  To mount two cvmfs volumes after setting up some defaults.
#
#  class { cvmfs:
#     cvmfs_http_proxy => 'http://squid1.example.org:3128;http://squid2.example.org:3128',
#     cvmfs_nfiles     => '20000'
#  }
#  cvmfs::mount{'atlas.example.org': cvmfs_quota => 5000}
#  cvmfs::mount{'cms.example.org': cvmfs_server_url => 'http://web.example.org/cms/' }
#
#  All defaults for repositories are maintained within params.pp
#  and by default params.pp uses hiera to get values though with data
#  binding you can now set cvmfs::init parameter driectly in hiera
#  if yo wish.
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
  $config_automaster          = $cvmfs::params::config_automaster,
  $cvmfs_quota_limit          = $cvmfs::params::cvmfs_quota_limit,
  $cvmfs_quota_ratio          = $cvmfs::params::cvmfs_quota_ratio,
  $cvmfs_http_proxy           = $cvmfs::params::cvmfs_http_proxy,
  $cvmfs_cache_base           = $cvmfs::params::cvmfs_cache_base,
  $cvmfs_timeout              = $cvmfs::params::cvmfs_timeout,
  $cvmfs_timeout_direct       = $cvmfs::params::cvmfs_timeout_direct,
  $cvmfs_nfiles               = $cvmfs::params::cvmfs_nfiles,
  $cvmfs_force_signing        = $cvmfs::params::cvmfs_force_signing,
  $cvmfs_syslog_level         = $cvmfs::params::cvmfs_syslog_level,
  $cvmfs_tracefile            = $cvmfs::params::cvmfs_tracefile,
  $cvmfs_debuglog             = $cvmfs::params::cvmfs_debuglog,
  $cvmfs_max_ttl              = $cvmfs::params::cvmfs_max_ttl,
  $cvmfs_hash                 = $cvmfs::params::cvmfs_hash,
  $cvmfs_version              = $cvmfs::params::cvmfs_version,
  $cvmfs_yum                  = $cvmfs::params::cvmfs_yum,
  $cvmfs_yum_testing          = $cvmfs::params::cvmfs_yum_testing,
  $cvmfs_yum_testsing_enabled = $cvmfs::params::cvmfs_yum_testing_enabled,
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
  if $cvmfs_hash {
    create_resources('cvmfs::mount', $cvmfs::params::cvmfs_hash)
  }
}
