# class: cvmfs::server:config
class cvmfs::server::config (
  $repo = undef,
  $nfshost = undef,
  $nfsshare = undef,
  $nfsopts  = 'rw,noatime,hard,nfsvers=3',
  $user     = 'shared',
  $nofiles  = 65000,
  $uid      = 101,
  $pubkey   = 'cern-it1.cern.ch.pub'
) {

  validate_string($pubkey)

  if $nfshost and $nfsshare {
    ::nfs::client::mount{'cvmfs_volume':
      ensure  => 'mounted',
      server  => $nfshost,
      share   => $nfsshare,
      mount   => '/srv/cvmfs',
      options => 'rw,noatime,hard,nfsvers=3',
      atboot  => true,
      require => [File['/srv/cvmfs'],Service['nfslock']],
      before  => [Exec['cvmfs_mkfs'],User[$user]],
    }
  }
  file{'/srv/cvmfs':
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => root,
    require => File['/srv'],
  }
  file{'/srv':
    ensure => directory,
    mode   => '0755',
    owner  => root,
    group  => root,
  }

  group{$user:
    gid => $uid,
  }
  user{$user:
    uid        => $uid,
    gid        => $uid,
    comment    => 'cvmfs shared account',
    managehome => true,
    home       => "/srv/cvmfs/${user}",
    require    => Group[$user],
  }

  ::limits::entry{'shared-soft':
    type   => 'soft',
    item   => 'nofile',
    value  => $nofiles,
    domain => 'shared',}
  ::limits::entry{'shared-hard':
    type   => 'hard',
    item   => 'nofile',
    value  => $nofiles,
    domain => 'shared',
  }

  exec{'cvmfs_mkfs':
    command => "/usr/bin/cvmfs_server mkfs -o ${user} ${repo}",
    creates => "/etc/cvmfs/repositories.d/${repo}",
    require => [User[$user],Package[kernel],Service['httpd']],
  }

  service{'httpd':
    ensure  => running,
    enable  => true,
    require => Package['httpd'],
  }
  #Switch off selinux for now.
  #disable SELinux.
  augeas {'disable_selinux':
    context => '/files/etc/sysconfig/selinux',
    incl    => '/etc/sysconfig/selinux',
    lens    => 'Shellvars.lns',
    changes => 'set SELINUX disabled',
    before  => Exec['cvmfs_mkfs'],
  } ~>
  exec {'/bin/echo 0 > /selinux/enforce': #apply the change immediately
    refreshonly => true,
    before      => Exec['cvmfs_mkfs'],
  }
  # Disable requiretty in sudoers since puppet runs mkfs with out a tty.
  augeas{'disable_requiretty':
    context => '/files/etc/sudoers',
    changes => 'set Defaults[*]/requiretty/negate ""',
    before  => Exec['cvmfs_mkfs'],
  }
  firewall{'100 - allow access from 80':
    proto  => 'tcp',
    dport  => 80,
    action => 'accept',
  }
  file{"/etc/cvmfs/keys/${repo}.pub":
    ensure => link,
    target => $pubkey,
  }

}
