# CVMFS

[![Build Status](https://github.com/voxpupuli/puppet-cvmfs/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-cvmfs/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-cvmfs/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-cvmfs/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/cvmfs.svg)](https://forge.puppet.com/puppet/cvmfs)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/cvmfs.svg)](https://forge.puppet.com/puppet/cvmfs)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/cvmfs.svg)](https://forge.puppet.com/puppet/cvmfs)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/cvmfs.svg)](https://forge.puppet.com/puppet/cvmfs)
[![Apache-2 License](https://img.shields.io/github/license/voxpupuli/puppet-cvmfs.svg)](LICENSE)

---

## Table of Contents

- [Overview](#overview)
- [What this module manages](#what-this-module-manages)
- [Getting started](#getting-started)
- [The `cvmfs` class: tuning what is managed](#the-cvmfs-class--tuning-what-is-managed)
- [The defined types](#the-defined-types)
  - [Which resource do I use?](#which-resource-do-i-use)
  - [`cvmfs::mount` -- mount a single repository](#cvmfsmount--mount-a-single-repository)
  - [`cvmfs::domain` -- mount a domain of repositories](#cvmfsdomain--mount-a-domain-of-repositories)
- [Mount method](#mount-method)
- [Autofs](#autofs)
- [The autofs master map](#the-autofs-master-map)
- [Prometheus metrics exporter](#prometheus-metrics-exporter)
- [Managing cvmfs fsck](#managing-cvmfs-fsck)
- [Custom facts](#custom-facts)
- [Limitations and deprecations](#limitations-and-deprecations)
- [Development](#development)
- [Support and authors](#support-and-authors)

---

## Overview

`puppet-cvmfs` installs, enables and configures
[CVMFS](https://cvmfs.readthedocs.io/en/stable/) (CernVM-FS) clients. CVMFS is a
distributed, read-only, on-demand filesystem that mounts large scientific
data repositories (such as those used by the HEP experiments) without you having
to manage the repositories by hand.

The module lets you describe CVMFS configuration through ordinary Puppet
manifests and/or external Hiera data. It manages the client, its package
repositories, its `default.local`/`default.conf` configuration, the individual
repository mounts (and domains of repositories), and - via the
[puppet-autofs](https://forge.puppet.com/puppet/autofs)
(https://github.com/voxpupuli/puppet-autofs) module - the autofs integration.

For general details on CVMFS see the
[CVMFS documentation](https://cvmfs.readthedocs.io/en/stable/).

---

## What this module manages

Depending on how you configure it, the module can manage these things:

| Element | Default location | Puppet representation | Managed by default? |
| --- | --- | --- | --- |
| The CVMFS package | - | `cvmfs` class (private `cvmfs::install`) | Yes |
| Package repositories (yum / apt) | `/etc/yum.repos.d`, `/etc/apt/sources.list.d` | `cvmfs::yum`, `cvmfs::apt` | Conditional (`repo_manage`) |
| Main client configuration | `/etc/cvmfs/default.local` | `cvmfs` class parameters / `cvmfs::config` | Yes |
| Repository configuration drop-ins | `/etc/cvmfs/config.d/*.local` | `cvmfs::mount` | Only when you declare them |
| Domain configuration drop-ins | `/etc/cvmfs/domain.d/*.local` | `cvmfs::domain` | Only when you declare them |
| autofs package, service and master map | `/etc/auto.cvmfs`, `/etc/auto.master` | `autofs` class, `cvmfs::autofs` | Yes (via the autofs module) |
| Prometheus metrics exporter | TCP port 9868 | `cvmfs` class parameter `enable_prometheus_exporter` | Conditional |
| Periodic `cvmfs fsck` cron job | system crontab | `cvmfs::fsck` | Conditional (`cvmfs_fsck`) |

> The `autofs` row covers `/etc/auto.master`, which is now owned entirely by the
> [puppet-autofs](https://github.com/voxpupuli/puppet-autofs) module rather than
> by this one. As a result the distribution's historically shipped default map
> entries (`/net`, `/misc`, `+auto.master`) are removed and, if required, must be
> re-added explicitly through the autofs module. See
> [The autofs master map](#the-autofs-master-map).

All of these can also be declared through Hiera hashes on the main `cvmfs`
class (see [The defined types](#the-defined-types)).

---

## Getting started

The minimal configuration installs CVMFS and mounts a single repository:

```puppet
class { 'cvmfs':
  cvmfs_http_proxy  => 'http://ca-proxy.example.org:3128',
  cvmfs_quota_limit => 100,
}

cvmfs::mount { 'files.example.org':
  cvmfs_server_url => 'http://web.example.org/cvmfs/files.example.org',
}
```

The module supplies sensible defaults for `repo_base` and `repo_base_alt`
(the apt/yum package repositories) via its internal Hiera data, which point at
CERN's public mirrors. To install from your own mirror instead, override them
(for example, in common Hiera):

```yaml
# conf/hiera/common.yaml
cvmfs::repo_base: 'https://your-mirror.example.org/cvmfs/yum'
cvmfs::repo_base_alt: 'https://your-mirror-alt.example.org/cvmfs/yum'
```

Mounts and domains can also be declared entirely through Hiera, rather than in
a manifest. Because `cvmfs_hash` and `cvmfs_domain_hash` are hashes, merge them
with `merge: hash` (see [The equivalent in Hiera](#the-equivalent-in-hiera)).

---

## The `cvmfs` class -- tuning what is managed

`class cvmfs (...)` is the entry point. Pulling it in installs the CVMFS package,
its repositories, and its configuration, and pulls in the autofs integration.
The most commonly used parameters are:

| Parameter | Default | Purpose |
| --- | --- | --- |
| `mount_method` | `autofs` | How repositories are mounted: `autofs`, `mount` (fstab), or `none` (see [Mount method](#mount-method)). |
| `repo_base` | *(required)* | URL of the apt/yum package repositories (CERN mirrors by default). |
| `repo_base_alt` | *(required)* | Second repository on a different backend, for failover. |
| `cvmfs_http_proxy` | `undef` | Squid proxy(es) to use, e.g. `http://proxy.example.org:3128`. |
| `cvmfs_quota_limit` | `1000` | Read cache quota in megabytes. |
| `config_repo` | `undef` | Repo to mount first (per-client configuration); used with `mount_method => 'mount'`. |
| `manage_autofs_service` | `true` | Manage the autofs package/service/master map via the autofs module. |
| `repo_manage` | `true` | Manage the yum/apt repositories. |
| `repo_gpgcheck` | `true` | Enable GPG checking of the package repositories. |
| `repo_proxy` | `undef` | HTTP proxy for the CVMFS yum/apt package repositories. |
| `cvmfs_version` | `present` | CVMFS package version to install. |
| `enable_prometheus_exporter` | `false` | Install and start the Prometheus exporter on port 9868. |
| `cvmfs_fsck` | `false` | Include the `cvmfs::fsck` cron class. |
| `cvmfs_hash` | `{}` | Hash of `cvmfs::mount` resources declared from Hiera. |
| `cvmfs_domain_hash` | `{}` | Hash of `cvmfs::domain` resources declared from Hiera. |

To *not* manage a piece, turn it off, for example set `repo_manage => false` to
leave package repositories to another tool, or
`manage_autofs_service => false` to stop managing autofs entirely.

The full parameter list, including every per-repo CVMFS tunable
(`cvmfs_timeout`, `cvmfs_memcache_size`, `cvmfs_world_readable`, and so on), is
in [REFERENCE.md](REFERENCE.md) under `class cvmfs`.

### The equivalent in Hiera

You do not have to touch a manifest. The same result is obtained by setting the
`cvmfs_hash` and `cvmfs_domain_hash` class parameters through Hiera. Both are
hashes, so merge them with `merge: hash`:

```yaml
# conf/hiera/common.yaml
lookup_options:
  cvmfs::cvmfs_hash:
    merge: hash
  cvmfs::cvmfs_domain_hash:
    merge: hash

cvmfs::cvmfs_hash:
  'files.example.org':
    cvmfs_server_url: 'http://web.example.org/cvmfs/files.example.org'

cvmfs::cvmfs_domain_hash:
  'example.net':
    cvmfs_server_url: 'http://web.example.org/cvmfs/@fqrn@'
```

---

## The defined types

The module exposes **two public defined types**, which differ only in the scope
of repositories they describe. Each one writes a small `.local` configuration
file under `/etc/cvmfs/config.d` (for a mount) or `/etc/cvmfs/domain.d` (for a
domain) and, unless `mount_method => 'none'`, arranges for the repository to be
mounted.

### Which resource do I use?

| What you want to put... | Use... |
| --- | --- |
| One individual repository | `cvmfs::mount` |
| A whole domain of repositories (`@fqrn@`) from a single server list | `cvmfs::domain` |

### `cvmfs::mount` -- mount a single repository

`cvmfs::mount` configures a single repository. Almost every parameter maps to a
lowercase `CVMFS_*` setting in that repository's `default.local` entry.

Most-used parameters:

| Parameter | Default | Purpose |
| --- | --- | --- |
| `repo` | the resource title | The fully qualified repository name. |
| `cvmfs_server_url` | `undef` | Stratum 1 server list, typically `;` delimited. Sets `CVMFS_SERVER_URL`. |
| `cvmfs_public_key` | `undef` | Public key for the repository. Sets `CVMFS_PUBLIC_KEYS`. |
| `cvmfs_quota_limit` | `undef` | Per-mount quota limit in MB. Sets `CVMFS_QUOTA_LIMIT`. |
| `cvmfs_timeout` | `undef` | HTTP timeout in seconds. Sets `CVMFS_HTTP_TIMEOUT`. |
| `mount_options` | `['defaults','_netdev','nodev']` | fstab mount options; `mount_method => 'mount'` only. |

**Manifest:**

```puppet
cvmfs::mount { 'lhcb.example.org': }

cvmfs::mount { 'atlas.example.org':
  cvmfs_timeout => 50,
}

cvmfs::mount { 'cms.example.org':
  cvmfs_timeout    => 100,
  cvmfs_server_url => 'http://web.example.org/cms.cern.ch',
}
```

**Hiera** (part of the `cvmfs_hash` hash; merge with `merge: hash`):

```yaml
cvmfs::cvmfs_hash:
  'files.example.org':
    cvmfs_server_url: 'http://web.example.org/cvmfs/files.example.org'
```

### `cvmfs::domain` -- mount a domain of repositories

`cvmfs::domain` configures a domain of repositories that share a server list.
It uses the same configuration file format as `cvmfs::mount`, so the relevant
parameters are the same; set `cvmfs_server_url` to an `@fqrn@` template so the
client rewrites the server list per repository.

```puppet
cvmfs::domain { 'example.org':
  cvmfs_server_url => 'http://host1.example.org/@repo@;http://host2.example2.org/@repo@',
  cvmfs_public_key => '/etc/cvmfs/keys/key1.pub,/etc/cvmfs/keys/key2.pub',
}
```

```yaml
cvmfs::cvmfs_domain_hash:
  'example.org':
    cvmfs_server_url: 'http://host1.example.org/@repo@;http://host2.example2.org/@repo@'
```

---

## Mount method

The `cvmfs` class accepts a `mount_method` parameter which selects how
repositories are mounted. The default, `autofs`, uses the
[puppet-autofs](https://forge.puppet.com/puppet/autofs) module (see
[Autofs](#autofs)). The `mount` option uses Puppet's `mount` type, currently
adding a line to `/etc/fstab`. The `none` option installs CVMFS but mounts
nothing. Migrating between `autofs` and `mount` is not supported.

To use Puppet's mount type rather than autofs, a typical configuration might be
the following. This example configures a cvmfs domain for common settings, a
configuration repository, and finally a particular repository to mount. In this
example `cvmfs-config.example.org` is the per-client configuration repository
and is always mounted first.

```puppet
class { 'cvmfs':
  mount_method => 'mount',
  config_repo  => 'cvmfs-config.example.org',
}

cvmfs::domain { 'example.org':
  cvmfs_server_url => 'http://web.example.org/cvmfs/@fqrn@',
}

cvmfs::mount { 'cvmfs-config.example.org':
  require => Cvmfs::Domain['example.org'],
}

cvmfs::mount { 'myrepo.example.org':
  require => Cvmfs::Domain['example.org'],
}
```

To install CVMFS without mounting anything:

```puppet
class { 'cvmfs':
  mount_method => 'none',
}
```

---

## Autofs

By default (`mount_method => 'autofs'`) all autofs management - the package, the
service, and the master map (`/etc/auto.cvmfs`) - is delegated to the
[puppet-autofs](https://forge.puppet.com/puppet/autofs)
(https://github.com/voxpupuli/puppet-autofs) module, and the `/cvmfs` automount
entry is declared as `autofs::mount` (a drop-in under the master map's
drop-in directory). See that module's README for the full list of options to
manage the autofs package and service.

Because management is delegated, **the autofs module's defaults apply and
`/etc/auto.master` is now fully maintained by Puppet** (managed all-or-nothing
via `autofs::mount` resources) - see
[The autofs master map](#the-autofs-master-map).

The `cvmfs::autofs` class additionally accepts the `manage_autofs_service`
parameter; when it is set to `false` neither the autofs service nor the `/cvmfs`
automount entry is managed. This is only relevant when `mount_method` is `autofs`.

## The autofs master map

Because the master map is now owned entirely by Puppet, the distribution's
historically shipped default entries are gone:

```
/net    -hosts
/misc   /etc/auto.misc
+auto.master
```

They are no longer present and, if required, must be re-added explicitly through
the autofs module. Declare each legacy entry directly:

```puppet
autofs::mount { 'net':
  mount   => '/net',
  mapfile => '-hosts',
  use_dir => true,
}

autofs::add_master_entry { '+auto.master': }
```

See the [puppet-autofs README](https://github.com/voxpupuli/puppet-autofs/blob/master/README.md)
(in particular its ["Migrating an existing `/etc/auto.master`"](https://github.com/voxpupuli/puppet-autofs/blob/master/README.md#migrating-an-existing-etcautomaster))
section, which explains how to convert such entries into
`autofs::mount` and `autofs::add_master_entry` resources.

---

## Prometheus metrics exporter

The optional `enable_prometheus_exporter` parameter installs and starts a
Prometheus exporter on port 9868.

```puppet
class { 'cvmfs':
  enable_prometheus_exporter => true,
}

class { 'nftables::rules::node_exporter':
  port => 9868,
}
```

---

## Managing cvmfs fsck

The optional class `cvmfs::fsck` can be included to enable a cron job that runs
`cvmfs fsck` regularly on the client.

```puppet
class { 'cvmfs':
  cvmfs_fsck          => true,
  cvmfs_fsck_options  => '-p',
  cvmfs_fsck_onreboot => true,
}
```

In addition, a cron is created to purge the quarantine of corrupted files after
30 days.

---

## Custom facts

The module ships one custom fact:

* `cvmfspartsize` returns the size, in megabytes, of the partition that
  contains `CVMFS_CACHE_BASE`. It is used to compute the default quota limit.

---

## Limitations and deprecations

* The `mount_method` is a per-client (main-class) setting and cannot be set on
  an individual `cvmfs::mount` or `cvmfs::domain` resource.
* Migrating between `autofs` and `mount` (or `none`) mount methods after install
  is not supported.
* Because autofs management is delegated to the autofs module, `/etc/auto.master`
  is managed all-or-nothing. The distro default entries (`/net`, `/misc`,
  `+auto.master`) are removed; re-add them with the autofs module if needed (see
  [The autofs master map](#the-autofs-master-map)).
* The `cvmfs_yum*` parameters are deprecated in favour of the `repo_*`
  parameters (`repo_base`, `repo_priority`, `repo_proxy`, `repo_gpgcheck`, etc.).
* See [CHANGELOG.md](CHANGELOG.md) for the full list of changes per release.

---

## Development

The full, machine-generated API reference is in
[REFERENCE.md](REFERENCE.md), covering the `cvmfs` class, every defined type,
custom fact, and function, including all parameters and their defaults.

Development follows the Vox Pupuli conventions shared across its modules:

* Unit tests use rspec-puppet (`spec/`); run with `rake spec`.
* Acceptance tests (`spec/acceptance`) provision nodes via
  [voxpupuli-acceptance](https://github.com/voxpupuli/test) (Beaker-based).
* CI runs on GitHub Actions (`.github/workflows/ci.yml`).

For the module's own metadata - its dependencies, supported operating systems,
and version requirements - see [metadata.json](metadata.json).

---

## Support and authors

For issues, feature requests, and documentation, see the project's home pages:

* GitHub: https://github.com/voxpupuli/puppet-cvmfs
* Puppet Forge: https://forge.puppet.com/puppet/cvmfs

Authors:

* Vox Pupuli: <voxpupuli@groups.io>
* Steve Traylen: <steve.traylen@cern.ch>
