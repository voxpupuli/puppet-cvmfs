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
To configure a cvmfs client to mount cvmfs repository or a domain
a domain of cvmfs repositories use the following.

```puppet
class{"cvmfs":
  cvmfs_http_proxy  => 'http://ca-proxy.example.org:3128',
  cvmfs_quota_limit => 100
}
cvmfs::mount{'files.example.org:
  cvmfs_server_url  => 'http://web.example.org/cvmfs/files.example.org',
}
```
or 

```puppet
class{"cvmfs":
  cvmfs_http_proxy  => 'http://ca-proxy.example.org:3128',
  cvmfs_quota_limit => 100,
}

cvmfs::domain{'example.net'
  cvmfs_server_url   => 'http://web.example.org/cvmfs/@fqrn@'
}
```

### Parameters to Cvmfs Class
* `config_automounter`  boolean defaults to true and configures the automounter for cvmfs.
* `manage_autofs_service` boolean defaults to true, should the autofs service be maintained.
* `cvmfs_quota_limit` The cvmfs quota size in megabytes. See params.pp for default.
* `cvmfs_quota_ratio` If set to ration, e.g '0.8' then 0.8 of the partition size
   the cvmfs cache is on will be used. Setting this assumes
   you have allocated a partition to cvmfs cache.
* `cvmfs_http_proxy` List of squid servers, see params.pp for default.
* `cvmfs_cache_base` Location of the CVMFS cache base, see params.pp for default.
* `cvmfs_mount_rw` Mount option to mount read-only or read/write, 'yes|no', see params.pp for default.
* `cvmfs_follow_redirects` Sets CVMFS_FOLLOW_REDIRECTS to its value, by default unset.
* `cvmfs_timeout` cvmfs timeout setting, see params.pp for default.
* `cvmfs_timeout_direct` cvmfs timeout to direct connections, see params.pp for default.
* `cvmfs_nfiles` Number of open files, system setting, see params.pp for default.
* `cvmfs_force_signing` Boolean defaults to true, repositories must be signed.
* `cvmfs_syslog_level`  Default is in params.pp
* `cvmfs_tracefile`  Create a tracefile at this location.
* `cvmfs_debuglog` Create a debug log file at this location.
* `cvmfs_max_ttl` Max ttl, see params.pp for default.
* `cvmfs_version` Version of cvmfs to install , default is present.
* `cvmfs_yum`  Yum repository URL for cvmfs.
* `cvmfs_yum_proxy` http proxy for cvmfs yum package repository
* `cvmfs_yum_config`  Yum repository URL for cvmfs site configs.
* `cvmfs_yum_config_enabled`  Defaults to false, set to true to enable.
* `cvmfs_yum_testing`  Yum repository URL for cmvfs testing repository.
* `cvmfs_yum_testing_enabled`  Defaults to false, should the testing repository be enabled.
* `cvmfs_yum_testsing_enabled` **TO DOC**
* `cvmfs_yum_gpgcheck`  Defaults to true, set to false to disable GPG checking (Do Not Do This)
* `cvmfs_yum_gpgkey`  Set a custom GPG key for yum repos, you must deploy it yourself.
* `cvmfs_yum_manage_repo` Defaults to true, set to false to disable yum repositories management.
* `cvmfs_use_geoapi`  **TO DOC**

* `cvmfs_hash` Rather than using cvmfs::mount defined type a hash of mounts can be sepecfied.
   cvmfs_hash {'myrepo' => {'cvmfs_server_url' => 'http://web.example.org/cvmfs/ams.example.org/}
* `cvmfs_env_variables`  $cvmfs_env_variables = {'CMS_LOCAL_SITE' => '<path to siteconf>'
   will produce
   `export CMS_LOCAL_SITE=<path to siteconf>`
   in the default.local file.


Puppet databindings allows all the above settings to be set via hiera. In
this case it is not nescesary to include `class{'cvmfs':}`.

```YAML
---
cvmfs::cvmfs_quota_limit: 100
cvmfs::cvmfs_nfiles: 20000
```


## Cvmfs::Mount Type
To mount individual repositories optionally with a particular
configuration on each repository. e.g

```puppet
cvmfs::mount{'lhcb.example.org':
}
cvmfs::mount{'atlas.example.org': 
  cvmfs_timeout => 50 
}
cvmfs::mount{'cms.example.org': 
  cvmfs_timeout    => 100,
  cvmfs_server_url => 'http://web.example.org/cms.cern.ch' 
}
```                                 

###  Cvmfs::Mount Type Parameters
* `namevar`  The namevar is the repository name, e.g atlas.example.ch
* `cvmfs_repo_list` A boolean defaults to `true`. Should this repository be 
   included in the list of repositories listed as `CVMFS_REPOSITORIES`
   with `/etc/cvmfs/default.local`.
* `cvmfs_follow_redirects` Sets CVMFS_FOLLOW_REDIRECTS to its value, by default unset.
* TBC


In addition to creating mounts as above the
`create_resources('cvmfs::mount',{})` function is called
allowing the mounts to be specified in a hiera yaml file:

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

## Cvmfs::Domain Type
A cvmfs domain file can be created with the cvmfs::domain type

```puppet
cvmfs::domain{'example.org':
     cvmfs_server_url => 'http://host1.example.org/@repo@;http://host2.example2.org/@repo@',
     cvmfs_public_key => '/etc/cvmfs/keys/key1.pub,/etc/cvmfs/keys/key2.pub'
}
```

###  Cvmfs::Domain Type Parameters
* `namevar`  The namevar is the domain name, e.g example.ch
* `cvmfs_follow_redirects` Sets CVMFS_FOLLOW_REDIRECTS to its value, by default unset.
* TBC


## Fsck Module
An optional class 'cvmfs::fsck' can be included to enable a cron job to regualarly
run fsck on cvmfs systems.

```puppet
class{'cvmfs::fsck':
   options => '-p',
   onreboot => true
}
```

In addition a cron will be created to purge quarentine corrupted files after 30 days.

### Fsck Options
* `options` Will pass parameters to the `cvmfs_fsck` command, by default none will be passed.
* `onreboot` If set to true a @reboot job will be set to run `cvmfs_fsck` at boot time. Default is false.

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
server. The previous class method will be deprecated at some future point.

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
* `auto_tag` Boolean to set `CVMFS_AUTO_TAG`, defaults to false.
* `garbage_collection` to set `CVMFS_GARBAGE_COLLECTION` defaults to false.
* `auto_gc` to set `CVMFS_AUTO_GC` defaults to false.
* `auto_gc_timespan` to set `CVMFS_AUTO_GC_TIMESPAN` defaults to `3 days ago`.
* `ignore_xdir_hardlinks` boolean to set to `CVMFS_IGNORE_XDIR_HARDLINKS` defaults to false.

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

## Tests
To run standalone tests

```bash
bundle install
bundle exec rake validate
bundle exec rake lint
bundle exec rake spec
```

The acceptance tests by default use docker
ensure that is working or provide beaker configuration
for your own hypervisor.


```bash
bundle install
BEAKER_debug=yes BEAKER_set=centos-7-x86_64-docker bundle exec rspec spec/acceptance
```


## License
Apache II License for all files except automaster.aug which is copied from
the http://augeas.net project. The automaster.aug file is LGPL v2+.

## Contact
Steve Traylen <steve.traylen@cern.ch>

## Support
https://github.com/cvmfs/puppet-cvmfs

