# == Define: cvmfs::mount
#
# Sets up a cvmfs mount entry such that it will be loaded by autofs.
#
# === Parameters
#
# [*namevar*]
#   The namevar is the repository name, e.g atlas.example.ch
#
# [*cvmfs_quota_limit*]
#   The cvmfs_quota_limit like all cvmfs_* parameters will
#   set the corresponding value, in this case CVMFS_QUOTA_LIMIT,
#   within /etc/cvmfs/config.d/${namevar}.local.
#   By default none of these variables are set since the nature
#   cvmfs is that it loads configuration from the default
#   files in /etc/cvmfs/default.*
#
# === Examples
# Enable atlas.exampe.org repository with a custome quota_limit value.
#
# cvmfs::mount{'atlas.example.org': cvmfs_quota_limit => '20000'}
#
# Enable ams.example.org repository with just one upstream web
# cvmfs server and special timeout.
#
# cvmfs::mount{'ams.cern.ch': cvmfs_server_url => 'http://web.example.org/ams.example.org/',
#                             cvmfs_timeout   =>  100}
#
# === Authors
#
# Steve Traylen <steve.traylen@cern.ch>
#
# === Copyright
#
# Steve Traylen <steve.traylen@cern.ch>
# == Parameters:
#
# $cvmfs_env_variables adds environment variables to the configuration
# example:
# $cvmfs_env_variables = {'CMS_LOCAL_SITE' => '<path to siteconf>'
# will produce
# export CMS_LOCAL_SITE=<path to siteconf>
# in the configuration
#
define cvmfs::mount($cvmfs_quota_limit = undef,
  $cvmfs_server_url = undef,
  $cvmfs_timeout = undef,
  $cvmfs_timeout_direct = undef,
  $cvmfs_nfiles = undef,
  $cvmfs_public_key = undef,
  $cvmfs_force_singing = undef,
  $cvmfs_max_ttl = undef,
  $cvmfs_env_variables = undef,
) {

  # We only even attempt to configure cvmfs if the following
  # two facts are available and that requires that cvmfs
  # has been installed first potentially on the first puppet
  # run.
  if $::cvmfsversion and $::cvmfspartsize {

    $repo = $name

    file{"/etc/cvmfs/config.d/${repo}.local":
      ensure  =>  file,
      content => template('cvmfs/repo.local.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Class['cvmfs::install'],
      notify  => Class['cvmfs::service']
    }
    if ! defined(Concat::Fragment['cvmfs_default_local_repo_start']) {
      concat::fragment{'cvmfs_default_local_repo_start':
        target  => '/etc/cvmfs/default.local',
        order   => 5,
        content => 'CVMFS_REPOSITORIES=\''
      }
    }
    concat::fragment{"cvmfs_default_local_${repo}":
      target  => '/etc/cvmfs/default.local',
      order   => 6,
      content => "${repo},"
    }
    if ! defined(Concat::Fragment['cvmfs_default_local_repo_end']) {
      concat::fragment{'cvmfs_default_local_repo_end':
        target  => '/etc/cvmfs/default.local',
        order   => 7,
        content => "'\n\n"
      }
    }
  }
}

