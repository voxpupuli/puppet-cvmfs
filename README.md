[![Puppet Forge](http://img.shields.io/puppetforge/v/CERNOps/cvmfs.svg)](https://forge.puppetlabs.com/CERNOps/cvmfs)
[![Build Status](https://travis-ci.org/cvmfs/puppet-cvmfs.svg?branch=master)](https://travis-ci.org/cvmfs/puppet-cvmfs)
# puppet-cvmfs


This cvmfs module is designed to install, enable and configure
CvmFS clients.

For general details on CvmFS see
http://cernvm.cern.ch/portal/filesystem

## Custom Facts
The module include one customfacts

* cvmfspartsize returns the size in megabytes of partition that contains the CVMFS_CACHE_BASE.

## Client Configuration
To configure a cvmfs client to mount cvmfs repository with
the default autofs.

```puppet
class{"cvmfs":
  cvmfs_http_proxy  => 'http://ca-proxy.example.org:3128',
  cvmfs_quota_limit => 100
}
cvmfs::mount{'files.example.org:
  cvmfs_server_url  => 'http://web.example.org/cvmfs/files.example.org',
}
```
To configure a cvmfs client to mount a domain of repositories
with autofs.

```puppet
class{"cvmfs":
  cvmfs_http_proxy  => 'http://ca-proxy.example.org:3128',
  cvmfs_quota_limit => 100,
}

cvmfs::domain{'example.net'
  cvmfs_server_url   => 'http://web.example.org/cvmfs/@fqrn@'
}
```

To use puppet's mount type rather that autofs
a typical configuration might be the following. This
examples configures a cvmfs domain, a configuration
repository and finally a particular repository for
mount.

```puppet
class{'::cvmfs':
  mount_method => 'mount',
}
cvmfs::domain{'example.org':
  cvmfs_server_url   => 'http://web.example.org/cvmfs/@fqrn@'
}
cvmfs::mount{'cvmfs-config.example.org':
  require => Cvmfs::Domain['example.org'],
}
cvmfs::mount{'myrepo.example.org':
  require => Cvmfs::Domain['example.org'],
}
```

### Parameters to Cvmfs Class
See [REFERENCE.md](REFERENCE.md)


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
See [REFERENCE.md](REFERENCE.md)

## Cvmfs::Domain Type
A cvmfs domain file can be created with the cvmfs::domain type

```puppet
cvmfs::domain{'example.org':
     cvmfs_server_url => 'http://host1.example.org/@repo@;http://host2.example2.org/@repo@',
     cvmfs_public_key => '/etc/cvmfs/keys/key1.pub,/etc/cvmfs/keys/key2.pub'
}
```

###  Cvmfs::Domain Type Parameters
See [REFERENCE.md](REFERENCE.md)

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

