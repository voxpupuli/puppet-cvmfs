#Class cvmfs::zero::config
#included from instances of cvmfs::zero defined type.
class cvmfs::zero::config {

  #Switch off selinux for now.
  #disable SELinux.
  augeas {'disable_selinux':
    context => '/files/etc/sysconfig/selinux',
    incl    => '/etc/sysconfig/selinux',
    lens    => 'Shellvars.lns',
    changes => 'set SELINUX disabled',
  } ~>
  exec {'/bin/echo 0 > /selinux/enforce': #apply the change immediately
    refreshonly => true,
  }
  # Disable requiretty in sudoers since puppet runs mkfs with out a tty.
  augeas{'disable_requiretty':
    context => '/files/etc/sudoers',
    changes => 'set Defaults[*]/requiretty/negate ""',
  }
  firewall{'100 - allow access from 80':
    proto  => 'tcp',
    dport  => 80,
    action => 'accept',
  }

  file{'/etc/cvmfs/repositories.d':
    ensure  => directory,
    purge   => true,
    recurse => true,
    require => Package['cvmfs-server'],
  }
  file{'/etc/httpd/conf.d':
    ensure  => directory,
    purge   => true,
    recurse => true,
    require => Package['httpd'],
    notify  => Service['httpd'],
  }
  file{'/etc/puppet-cvmfs-scripts':
    ensure  => directory,
    purge   => true,
    recurse => true,
  }
  file{'/etc/puppet-cvmfs-scripts/README':
    ensure  => file,
    content => "A few puppet generate scripts to aid operation.\n",
  }
}
