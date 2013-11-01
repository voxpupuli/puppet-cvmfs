# == Class cvmfs::server
# This class will set up a cvmfs server
# === Variables
# [*repo*]
# This is the namevar , it should be set to the name of repository, e.g mysoftware.example.org, if
# not set the namevar will be used.
# [*nfshost*]
# [*nfsshare*]
# If set then an nfsvolume will be mounted early on before all the cvmfs configuration is done.
# e.g nfsserver.example.org:/Volume/example
# [*nfsoptions*]
# Nfs options can be set, there is a sensible default as below.
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


