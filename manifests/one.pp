# == Define: cvmfs::one
# Sets up a stratum one service for CVMFS.
#
# === Parameters
# [*repo*]
#  The name of the repostory, if the repo is not set the *namevar* will be used.
#
# [*origin*]
#  The URL prefix of the stratum zero endpoint, the repo name will be appended to the end.
#
# [*keys*]
#  An array of keys to use for a repository. The default value is
#  ['/etc/cvmfs/keys/cern.ch.pub','/etc/cvmfs/keys/cern-it1.cern.ch.pub','/etc/cvmfs/keys/cern-it2.cern.ch.pub']
#
# === Examples
#   cvmfs::one{'mice.example.org':
#     origin => 'http://cvmfs01.example.org/cvmfs',
#     keys   => ['/etc/cvmfs/keys/example1.pub','/etc/cvmfs/keys/example1.pub']
#   }
# === Copyright
# Steve Traylen, <steve.traylen@cern.ch>, CERN 2013.
define cvmfs::one (
  $repo = $name,
  $origin = 'http://stratum0.example.org/cvmfs',
  $keys = ['/etc/cvmfs/keys/cern.ch.pub','/etc/cvmfs/keys/cern-it1.cern.ch.pub','/etc/cvmfs/keys/cern-it2.cern.ch.pub']
) {
  include '::cvmfs::one::install'
  include '::cvmfs::one::config'

  $joinedkeys = join($keys,':')
  exec{"replicate_${name}":
    command => "/usr/bin/cvmfs_server add-replica -o cvmfsr ${origin}/${repo} ${joinedkeys}",
    creates => "/etc/cvmfs/repositories.d/${repo}/replica.conf",
    require => [User['cvmfsr'],Package['cvmfs-server'],Service['httpd']],
  }
  file{"/etc/httpd/conf.d/cvmfs.${repo}.conf":
    ensure  => file,
    mode    => '0644',
    owner   => root,
    group   => root,
    content => template('cvmfs/cvmfs-strat1-httpd.conf.erb'),
    require => Package['httpd'],
    notify  => Service['httpd'],
  }
}
