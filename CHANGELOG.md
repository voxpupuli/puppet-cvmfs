##2015-04-29 - Release 0.4.0

###Features
- New paramter `cvmfs_repo_list` allows entries of CVMFS_REPOSITORIES to be fine
  tuned per cvmfs::mount. https://github.com/cvmfs/puppet-cvmfs/pull/22
- New paramter `manage_autofs_service` controls if autofs service should
  be managed module. Existing paramter `config_automaster` now only configures
  `auto.master file` - @jcpunk.
- New type cvmfs::zero to configure a CvmFS stratum 0. The existing
  class cvmfs::server for stratum 0s will be deprecated at some 
  future date.
- Doc changes for latest PL style guide. CHANGELOG is now markdown.
  Docs for classes and types being migrated from them to README.md.
- puppet-cvmfs is now autodeployed to puppetforge once tagged.
- CvmFS env settings can now be set globally as well per domain or mount.
- New variable `cvmfs_domain_hash` allows a hash of CvmFS domains to 
  loaded from hiera.
- New variable `cvmfs_use_geoapi` can be set globally, per domain or
  mount to influence `CVMFS_USE_GEOAPI`
- rspec functional tests now exist for class cvmfs and types 
  cvmfs::zero, cvmfs::mount and cvmfs::domain.


###Bugfixes
- cvmfs-config* packages can now be installed on cvmfs servers.
- All references to deprecated concat::setup removed - @berghaus.
- Vague use of undef was failing under furture parser or puppet
  4.0

##2015-03-06 - Release 0.3.3

###Features
- do not control autofs service when asked not to.
- Install mod_wsgi and configure for geoip on stratum 1.
- Allow a http proxy for yum repos to be configured.
- Migrate to puppetlabs lint tests.

###Bugfixes

##2014-06-18 - Release 0.3.2

###Features
- server - seperate yum configuration for server and client.
- server - Add `nofiles` paramter to server class to allow no open files to 
  be specified for the user running the cvmfs server.
- server - An exact kernel version is no longer specified.
- README file converted to markdown, now README.md.
- client - new defined type cvmfs::domain to create <domain>.local file in 
  /etc/cvmfs/domain.d.
- client - cvmfs::init class is now paramatised so supports that in addition to hiera.

###Bugfixes
- server - force a public key file location to be specified.
- server - when disabling selinux on server specify an augeas scope

##2014-03-27 - Release 0.2.2

###Features

###Bugfixes
- bugfix for cvmfs_public_key variable.

##2014-01-16 - Release 0.2.1

###Features

###Bugfixes
-  Puppet 3.4 compatability for ensure_resources.
