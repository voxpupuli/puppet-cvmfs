# Class: cvmfs::one::config
# Included once from the cvmfs::one defined type.
class cvmfs::one::config {

  firewall{'100 - allow access from 80':
    proto  => 'tcp',
    dport  => 80,
    action => 'accept',
  }

  service{'httpd':
    ensure  => running,
    enable  => true,
    require => Package['httpd'],
  }

  user{'cvmfsr':
    ensure     => present,
    home       => '/var/lib/cvmfsr' ,
    comment    => 'cvmfs repication account',
    managehome => true,
    system     => true,
  }

  cron{'cvmfs_sync':
    user    => cvmfsr,
    minute  => '*/15',
    command => '/usr/local/sbin/sync-cron.sh',
    require => File['/usr/local/sbin/sync-cron.sh'],
  }
  file{'/usr/local/sbin/sync-cron.sh':
    ensure => file,
    mode   => '0755',
    owner  => root,
    group  => root,
    source => 'puppet:///modules/cvmfs/sync-cron.sh',
  }

  file{'/var/log/cvmfs':
    ensure  => directory,
    owner   => cvmfsr,
    group   => cvmfsr,
    require => User['cvmfsr'],
  }
  file{'/etc/logrotate.d/cvmfsr':
    ensure => file,
    owner  => root,
    group  => root,
    source => 'puppet:///modules/cvmfs/cvmfsr.logrotate',
  }

}

