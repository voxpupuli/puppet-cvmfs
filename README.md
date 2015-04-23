[![Puppet Forge](http://img.shields.io/puppetforge/v/CERNOps/cvmfs.svg)](https://forge.puppetlabs.com/CERNOps/cvmfs)
[![Build Status](https://travis-ci.org/cvmfs/puppet-cvmfs.svg?branch=master)](https://travis-ci.org/cvmfs/puppet-cvmfs)
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

* global defaults - /etc/cvmfs/default.local
* domain settings - /etc/cvmfs/domain.d/
* repository settings - /etc/cvmfs/config.d/

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

## Stratum 0 Configuration
There are currently two options to configure a stratum 0. 
The class method only supports one stratum one and will
at some point be deprecated. 

### Stratum 0 Configuration as a Class
```puppet
class{'cvmfs::server':
 repo   => 'ilc.example.org',
 pubkey => 'public.example.org'
}
```

See the docs in cvmfs::server for explanation of parameters.

### Stratum 0 Configuration as a Defined Type
A new method where each stratum 0 can be configured as an instance. 
The advantage here is that multiple stratum zeros can be configured per 
server. The previous class method will deprecated at some future point.

```puppet
cvmfs::zero{'files.example.org':
   repo_store => '/mybigdisk',
   spool_store => '/var/spool/cvmfs',
   user        => steve,
   uid         => 500
}
```
#### Stratum 0 Parameters

* `clientuesr` If set will specify the user running the cvmfs_client on the server. Optinal.
* `claim_ownership`. By default false if true it enables the `CVMFS_CLAIM_OWNERSHIP` option the server's client instance.
* `group` The group name that will manage the repository and own the files on the server. 
* `home` The home directory of the `user` account that owns the cvmfs repositories. The default value is
   `repo_store`/`repo`/`user`.
* `gid` The gid fo the `group`, it defaults to the be same as the `uid`, defaults to the `user` setting.
* `repo the fully qualified repository name. Defaults the *name* value of the instance. e.g `example.domain.org`.
* `repo_store` large disk location where the cvmfs repositories are stored. Defaults to `/srv/cvmfs`.
* `nofiles` The nofiles the `user` is permitted to open. Defaults to `65000`
* `spool_store` location of files internal to a cvmfs server.
* `uid` The uid of the `user`
* `user` The user name that will manage the repository and own the files on the server.

#### Stratum 0 Examples
A common case is to mount a device or nfs storage volume to use as the repo
store. In this case the mount should happen before cvmfs::zero populates the
area. For example two repositories stoed on two block device `/dev/vdb` and `/dev/vdc`.

```puppet
mount{'/srv/cvmfs/files.example.org':
  ensure  => mounted,
  device  => '/dev/vdb',
  options => 'rw,noatime,nodiratime,nobarrier,user_xattr'
  require => File['/srv/cvmfs/files.example.org'],
  before  => File['/srv/cvmfs/files.example.org/data']
}
mount{'/srv/cvmfs/objects.example.org':
  ensure  => mounted,
  device  => '/dev/vdc',
  options => 'rw,noatime,nodiratime,nobarrier,user_xattr'
  require => File['/srv/cvmfs/objects.example.org'],
  before  => File['/srv/cvmfs/objects.example.org/data']
}

cvmfs::zero{'files.example.org':
   user => 'steve',
   uid  => 200,
}
cvmfs::zero{'objects.example.org':
   user => 'andrew',
   uid  => 201,
}

```

### Migrating Stratum 0 Class to Stratum 0 Type
The class based stratum 0 will be deprecated at some point. The differences are:

1. The new type no longer attempts to manage a symbolic link to a master key.
  If desired this should be done by the  addition of symbolic link outside of `cvmfs::zero`.
2. The new type no longer supports mounting e.g nfs volumes. This myst be done
  externally as per the example above.


Replacing 

```puppet
class{'cvmfs::server':
 repo   => 'ilc.example.org',
 pubkey => 'public.example.org',
 user   => 'shared',
 uid    => 101
}
```

with 

```puppet
cvmfs::zero{'ilc.example.org':
   user => shared,
   uid  => 101
}
file{'/etc/cvmfs/keys/ilc.example.org':
   ensure  => link,
   target  => '/etc/cvmfs/keys/public.example.org.pem',
   require => Package['cvmfs']
}
```

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

## License
Apache II License for all files except automaster.aug which is copied from
the http://augeas.net project. The automaster.aug file is LGPL v2+.

## Contact
Steve Traylen <steve.traylen@cern.ch>

## Support
https://github.com/cvmfs/puppet-cvmfs

