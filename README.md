[![Puppet Forge](http://img.shields.io/puppetforge/v/puppet/cvmfs.svg)](https://forge.puppetlabs.com/puppet/cvmfs)
# puppet-cvmfs


This cvmfs module is designed to install, enable and configure
CvmFS clients.

For general details on CvmFS see
http://cernvm.cern.ch/portal/filesystem

This module obsoletes [CERNOps-cvmfs-7.3.0](https://forge.puppet.com/modules/CERNOps/cvmfs)

## Custom Facts
The module include one customfact

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

## Managing cvmfs fsck
The optional class 'cvmfs::fsck' can be included to enable a cron job to regualarly run fsck on cvmfs systems.

```puppet
class{'cvmfs':
   cvmfs_fsck => true,
   cvmfs_fsck_options  => '-p',
   cvmfs_fsck_onreboot => true
}
```

In addition a cron will be created to purge quarentine corrupted files after 30 days.

### Fsck Options
See [REFERENCE.md](REFERENCE.md) and the CVMFS documentation.

## License
Apache II License for all files except automaster.aug which is copied from
the http://augeas.net project. The automaster.aug file is LGPL v2+.

## Contact
Steve Traylen <steve.traylen@cern.ch>

## Support
https://github.com/voxpupuli/puppet-cvmfs

