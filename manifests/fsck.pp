# Enable this class to run a weekly cron job to fsck your cache.
class cvmfs::fsck (
  $cvmfs_cache_base = $cvmfs::params::cvmfs_cache_base
) inherits cvmfs::params {

  cron{'cvmfs_fsck':
    hour      => fqdn_rand(24),
    minute    => fqdn_rand(60),
    weekday   => fqdn_rand(7),
    command   => "( date ; /bin/nice /usr/bin/cvmfs_fsck ${cvmfs_cache_base}/shared )  >> /var/log/cvmfs_fsck.log 2>&1"
  }
  file{'/etc/logrotate.d/cvmfs_fsck':
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/cvmfs/cvmfs_fsck.logrotate'
  }
}

