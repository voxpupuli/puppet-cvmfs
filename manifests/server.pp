# == Class cvmfs::server
# This class will set up a cvmfs server

# === Parameters
# [*repo*]
# This is the namevar , it should be set to the name of repository, e.g mysoftware.example.org, if
# not set the namevar will be used.
# [*nfshost*]
# [*nfsshare*]
# If *nfshost* and *nfsshare* are set then an nfsvolume will be mounted early on before all the cvmfs
# configuration is done.
# [*nfsoptions*]
# Nfs options can be set, there is a sensible default as below.
# [*pubkey*]
# The name of pubkey to be used. It is assume the pubkey is in the directory
# '/etc/cvmfs/keys'
#
# === Examples
#    class{'cvmfs::server':
#      repo   => 'ilc.example.org',
#      pubkey => 'key.example.org'
#    }
# or
#    class{'cvmfs::server':
#      repo       => 'bute.example.org',
#      nfshost    => 'nfs-server.example.org',
#      nfsshare   => '/volume/bute'
#      nfsoptions => 'noatime',
#      pubkey     => 'key.example.org'
#
class cvmfs::server ($repo     = $name,
  $pubkey,
  $nfsshare = undef,
  $nfshost  = undef,
  $nfsopts  = 'rw,noatime,hard,nfsvers=3',
  $user     = 'shared',
  $nofiles  = 65000,
  $uid      = 101,
  $cvmfs_yum_kernel         = $cvmfs::params::cvmfs_yum_kernel,
  $cvmfs_yum_kernel_enabled = $cvmfs::params::cvmfs_yum_kernel_enabled,
  $cvmfs_yum                  = $cvmfs::params::cvmfs_yum,
  $cvmfs_yum_testing          = $cvmfs::params::cvmfs_yum_testing,
  $cvmfs_yum_testing_enabled = $cvmfs::params::cvmfs_yum_testing_enabled,
)
{
  class{'::cvmfs::server::install':}
  class{'::cvmfs::server::config':
    repo     => $repo,
    nfsshare => $nfsshare,
    nfshost  => $nfshost,
    nfsopts  => $nfsopts,
    user     => $user,
    nofiles  => $nofiles,
    uid      => $uid,
    pubkey   => $pubkey,
    require  => Class['cvmfs::server::install'],
  }
}


