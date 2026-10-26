[![Puppet Forge](http://img.shields.io/puppetforge/v/puppet/cvmfs.svg)](https://forge.puppetlabs.com/puppet/cvmfs)
# puppet-cvmfs


This cvmfs module is designed to install, enable and configure
CvmFS clients.

For general details on CvmFS see
http://cernvm.cern.ch/portal/filesystem

For a record of breaking and notable changes, see [CHANGELOG.md](CHANGELOG.md).

## Getting started

The minimal configuration installs CVMFS and mounts a single repository:

```puppet
class{'cvmfs':
  cvmfs_http_proxy  => 'http://ca-proxy.example.org:3128',
  cvmfs_quota_limit => 100,
}
cvmfs::mount{'files.example.org':
  cvmfs_server_url => 'http://web.example.org/cvmfs/files.example.org',
}
```

The module supplies sensible defaults for `repo_base` and `repo_base_alt`
(the apt/yum package repositories) via its internal Hiera data, which point at
CERN's public mirrors. To install from your own mirror instead, override them
(e.g. in common Hiera):

```yaml
# conf/hiera/common.yaml
cvmfs::repo_base: 'https://your-mirror.example.org/cvmfs/yum'
cvmfs::repo_base_alt: 'https://your-mirror-alt.example.org/cvmfs/yum'
```

See [REFERENCE.md](REFERENCE.md) for the full list of class parameters.

## Autofs
By default (`mount_method => 'autofs'`) all autofs management - the package,
the service, and the master map (`/etc/auto.cvmfs`) - is delegated to the
[puppet/autofs](https://forge.puppet.com/puppet/autofs)
(https://github.com/voxpupuli/puppet-autofs) module, and the `/cvmfs` automount
entry is declared as `autofs::mount`. See that module's README for the full list
of options to manage the autofs package and service.

The `cvmfs::autofs` class additionally accepts the `manage_autofs_service`
parameter; when it is set to `false` neither the autofs service nor the `/cvmfs`
automount entry is managed. This is only relevant when `mount_method` is `autofs`.

## Client Configuration
To configure a cvmfs client to mount cvmfs repository with
the default autofs.

```puppet
class{"cvmfs":
  cvmfs_http_proxy  => 'http://ca-proxy.example.org:3128',
  cvmfs_quota_limit => 100,
}

cvmfs::mount{'files.example.org':
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

cvmfs::domain{'example.net':
  cvmfs_server_url   => 'http://web.example.org/cvmfs/@fqrn@'
}
```

### Mount Method
The `cvmfs` class accepts a `mount_method` parameter which selects how
repositories are mounted. The default, `autofs`, uses the
[puppet/autofs](https://forge.puppet.com/puppet/autofs) module (see
[Autofs](#autofs)). The `mount` option uses puppet's `mount` type, currently
adding a line to `/etc/fstab`. The `none` option installs CVMFS but mounts
nothing.

To use puppet's mount type rather than autofs a typical configuration might be
the following. This example configures a cvmfs domain for common settings, a
configuration repository and finally a particular repository for mount. In this
example the `cvmfs-config.example.org` has been marked as the per client
configuration repository and will always be mounted first.

```puppet
class{'cvmfs':
  mount_method => 'mount',
  config_repo  => 'cvmfs-config.example.org',
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

To install CVMFS without mounting anything:

```puppet
class{'cvmfs':
  mount_method => 'none',
}
```

### Declaring mounts and domains via Hiera
Rather than declaring each `cvmfs::mount` and `cvmfs::domain` resource in a
manifest, the same mounts and domains can be declared entirely through Hiera
using the `cvmfs_hash` and `cvmfs_domain_hash` parameters:

```yaml
# conf/hiera/common.yaml
cvmfs::cvmfs_hash:
  'files.example.org':
    cvmfs_server_url: 'http://web.example.org/cvmfs/files.example.org'

cvmfs::cvmfs_domain_hash:
  'example.net':
    cvmfs_server_url: 'http://web.example.org/cvmfs/@fqrn@'
```

### Cvmfs::Mount Type
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

### Cvmfs::Domain Type
A cvmfs domain file can be created with the cvmfs::domain type

```puppet
cvmfs::domain{'example.org':
     cvmfs_server_url => 'http://host1.example.org/@repo@;http://host2.example2.org/@repo@',
     cvmfs_public_key => '/etc/cvmfs/keys/key1.pub,/etc/cvmfs/keys/key2.pub'
}
```

### Prometheus Metrics Exporter
The optional `enable_prometheus_exporter` parameter installs and starts a
Prometheus exporter on port 9868.

```puppet
class{ 'cvmfs':
  enable_prometheus_exporter => true,
}
class{ 'nftables::rules::node_exporter':
  port => 9868,
}
```

## Managing cvmfs fsck
The optional class 'cvmfs::fsck' can be included to enable a cron job to run
regularly fsck on cvmfs systems.

```puppet
class{'cvmfs':
   cvmfs_fsck => true,
   cvmfs_fsck_options  => '-p',
   cvmfs_fsck_onreboot => true
}
```

In addition a cron will be created to purge quarantine corrupted files after 30 days.

## Custom Facts
The module includes one custom fact

* `cvmfspartsize` returns the size in megabytes of partition that contains the CVMFS_CACHE_BASE.

## Support and authors

For issues, feature requests, and documentation, see the project's home pages:

* GitHub: https://github.com/voxpupuli/puppet-cvmfs
* Puppet Forge: https://forge.puppet.com/puppet/cvmfs

Authors:

* Vox Pupuli: <voxpupuli@groups.io>
* Steve Traylen: <steve.traylen@cern.ch>
