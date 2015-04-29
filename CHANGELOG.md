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
