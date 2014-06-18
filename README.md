# puppet-cvmfs

This cvmfs module is designed to install, enable and configure
CvmFS clients and servers.

For general details on CvmFS see
http://cernvm.cern.ch/portal/filesystem 

## Custom Facts
The module include two customfacts

* cvmfsversion returns the version of cvmfs installed as supplied by '/usr/bin/cvmfs2 --version'
* cvmfspartsize returns the size in megabytes of partition that contains the CVMFS_CACHE_BASE.

These facts will only be available once cvmfs is installed and so configuration
of cvmfs is skipped until cvmfs has been installed on the first puppet run.
Two puppet runs are required to install and then configure cvmfs.

## Client Configuration
To configure a cvmfs client enable the module

```puppet
class{cvmfs:}
```

and then enable individual repositories optionally with a particular
configuration on each repository. e.g.

```puppet
cvmfs::mount{'lhcb.example.org':
}
cvmfs::mount{'atlas.example.org': cvmfs_quota    => 50 
}
cvmfs::mount{'cms.example.org': 
  cvmfs_quota      => 100,
  cvmfs_server_url => 'http://web.example.org/cms.cern.ch' 
}
```                                 
The global defaults for all repositories are maintained within
params.pp. This file supports hiera as a data source so use hiera
or change the values in params.pp. These global values 
end up in /etc/cvmfs/cvmfs.local.

Or the cvmfs::init class is paramatized so specifying values 
as parameters is also possible.

```puppet
class{'cvmfs':
  cvmfs_quota      => 100
  cvmfs_server_url => 'http://web.example.org/cvmfs/cmfs.example.org'
}
```

puppet data bindings can be used to specify these values within hiera

```YAML
---
cvmfs::cvmfs_quota: 100
```

In addition to creating mounts as above the
create_resources('cvmfs::mount',{}) function is enabled
to allow the mounts to specified in a hiera yaml file:

```YAML
---
cvmfs::mount:
  atlas.example.ch:
    cvmfs_quota_limit: 10000
  atlas-condb.example.ch:
       {}
  atlas-nightlies.example.ch:
    cvmfs_server_url: http://cvmfs-atlas-nightlies.example.ch/cvmfs/atlas-nightlies.example.ch
```

which will enable these three mount points with the specified options.

CvmFS supports 3 locations for configuration.
* global defaults - /etc/cvmfs/default.*
* domain settings - /etc/cvmfs/domain.d/*
* repository settings - /etc/cvmfs/config.d/*

A cvmfs domain file can be created with the cvmfs::domain type

```puppet
cvmfs::domain{'example.org':
     cvmfs_server_url => 'http://host1.example.org/@repo@;http://host2.example2.org/@repo@',
     cvmfs_public_key => '/etc/cvmfs/keys/key1.pub,/etc/cvmfs/keys/key2.pub'
}
```


## Fsck Module
An optional class 'cvmfs::fsck' can be included to enable a cron job to regualarly
run fsck on cvmfs systems.

```puppet
include ('cvmfs::fsck')
```

## Server Configuration
A stratum zero can be configured with a simple.

```puppet
class{'cvmfs::server':
 repo   => 'ilc.example.org',
 pubkey => 'public.example.org'
}
```

See the docs in cvmfs::server for explanation of parameters.

Stratum One Configuration
------------------------
A stratum one can be configured for multiple repositories with
a 
```puppet
cvmfs::one{'mice.example.org':
  origin => 'http://cvmfs01.example.org/cvmfs',
  keys   => ['/etc/cvmfs/keys/example1.pub','/etc/cvmfs/keys/example1.pub']
}
```

See cvmfs::one.pp for more details of parameters.

## ToDo
It's now possible to install multiple stratum zeros in the same
node. This module does not support that and it should.

## License
Apache II License for all files except automaster.aug which is copied from
the http://augeas.net project. The automaster.aug file is LGPL v2+.

## Contact
Steve Traylen <steve.traylen@cern.ch>

## Support
https://github.com/cvmfs/puppet-cvmfs

