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
#
# === Examples
#    class{'cvmfs::server':
#      repo => 'ilc.example.org',
#    }
# or
#    class{'cvmfs::server':
#      repo       => 'bute.example.org',
#      nfshost    => 'nfs-server.example.org',
#      nfsshare   => '/volume/bute'
#      nfsoptions => 'noatime',
#
class cvmfs::server ($repo     = $name,
  $nfsshare = undef,
  $nfshost  = undef,
  $nfsopts  = 'rw,noatime,hard,nfsvers=3',
  $user     = 'shared',
  $uid      = 101)
{
  class{'cvmfs::server::install':}
  class{'cvmfs::server::config':
    repo     => $repo,
    nfsshare => $nfsshare,
    nfshost  => $nfshost,
    nfsopts  => $nfsopts,
    user     => $user,
    uid      => $uid,
    require  => Class['cvmfs::server::install']
  }
}


