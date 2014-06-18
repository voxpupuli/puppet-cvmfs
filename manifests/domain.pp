# == Define: cvmfs::domain
#
# Sets up a cvmfs domain entry such that members of the domain
# will be loaded by autofs.
#
# === Parameters
#
# [*namevar*]
#   The namevar is the domain name, e.g example.ch
#
# [*cvmfs_quota_limit*]
#   The cvmfs_quota_limit like all cvmfs_* parameters will
#   set the corresponding value, in this case CVMFS_QUOTA_LIMIT,
#   within /etc/cvmfs/domain.d/${namevar}.local.
#   By default none of these variables are set since the nature
#   cvmfs is that it loads configuration from the default
#   files in /etc/cvmfs/default.*
#
# === Examples
# Enable example.org domain with a custom quota_limit value.
#
# cvmfs::mount{'example.org': cvmfs_quota_limit => '20000'}
#
# Enable example.org domain with just one upstream web
# cvmfs server and special timeout.
#
# cvmfs::domain{'example.org': cvmfs_server_url => 'http://web.example.org/ams.example.org/',
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
define cvmfs::domain($cvmfs_quota_limit = undef,
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

    # In this case the repo is really a domain
    # but it's the same configuration file format
    # so we resuse the template.
    $repo = $name

    file{"/etc/cvmfs/domain.d/${repo}.local":
      ensure  =>  file,
      content => template('cvmfs/repo.local.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Class['cvmfs::install'],
      notify  => Class['cvmfs::service']
    }
  }
}

