# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v8.0.0](https://github.com/voxpupuli/puppet-cvmfs/tree/v8.0.0) (2021-03-23)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/v7.3.0...v8.0.0)

**Breaking changes:**

- Remove 'yum' string from class parameters [\#123](https://github.com/voxpupuli/puppet-cvmfs/pull/123) ([traylenator](https://github.com/traylenator))
- Add type enforcement to cvmfs::mount and cvmfs::domain [\#122](https://github.com/voxpupuli/puppet-cvmfs/pull/122) ([traylenator](https://github.com/traylenator))
- Drop all CvmFS server code [\#113](https://github.com/voxpupuli/puppet-cvmfs/pull/113) ([traylenator](https://github.com/traylenator))

**Implemented enhancements:**

- Add CVMFS\_IPFAMILY\_PREFER config parameter [\#125](https://github.com/voxpupuli/puppet-cvmfs/pull/125) ([luisfdez](https://github.com/luisfdez))
- Add ubuntu 18.04, 20.04 and debian 10 support [\#124](https://github.com/voxpupuli/puppet-cvmfs/pull/124) ([traylenator](https://github.com/traylenator))
- Convert main config template to epp [\#118](https://github.com/voxpupuli/puppet-cvmfs/pull/118) ([traylenator](https://github.com/traylenator))

**Fixed bugs:**

- cvmfs\_external\_url parameter to mount fixed [\#127](https://github.com/voxpupuli/puppet-cvmfs/pull/127) ([traylenator](https://github.com/traylenator))
- Correct parameter name for default case [\#126](https://github.com/voxpupuli/puppet-cvmfs/pull/126) ([traylenator](https://github.com/traylenator))

**Merged pull requests:**

- Update all documentation [\#128](https://github.com/voxpupuli/puppet-cvmfs/pull/128) ([traylenator](https://github.com/traylenator))
- Use modern splat rather than create resources [\#121](https://github.com/voxpupuli/puppet-cvmfs/pull/121) ([traylenator](https://github.com/traylenator))
- Whitespace, Automatic lint and Rubocop Fixes [\#114](https://github.com/voxpupuli/puppet-cvmfs/pull/114) ([traylenator](https://github.com/traylenator))
- Increase upper version of firewall module [\#112](https://github.com/voxpupuli/puppet-cvmfs/pull/112) ([sorrison](https://github.com/sorrison))
- cvmfs::install: Fact file creation must depend on Package\[cvmfs\]. [\#111](https://github.com/voxpupuli/puppet-cvmfs/pull/111) ([olifre](https://github.com/olifre))
- Add UID\_MAP and GID\_MAP functionality. [\#110](https://github.com/voxpupuli/puppet-cvmfs/pull/110) ([olifre](https://github.com/olifre))
- add missing package require for file ownership [\#104](https://github.com/voxpupuli/puppet-cvmfs/pull/104) ([fschaer](https://github.com/fschaer))

## [v7.3.0](https://github.com/voxpupuli/puppet-cvmfs/tree/v7.3.0) (2020-08-13)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/v7.2.0...v7.3.0)

**Merged pull requests:**

- New cvmfs\_repositories parameter [\#106](https://github.com/voxpupuli/puppet-cvmfs/pull/106) ([traylenator](https://github.com/traylenator))

## [v7.2.0](https://github.com/voxpupuli/puppet-cvmfs/tree/v7.2.0) (2020-08-11)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/v7.1.1...v7.2.0)

**Merged pull requests:**

- Support per mount CVMFS\_REPOSITORY\_TAG specification [\#105](https://github.com/voxpupuli/puppet-cvmfs/pull/105) ([traylenator](https://github.com/traylenator))

## [v7.1.1](https://github.com/voxpupuli/puppet-cvmfs/tree/v7.1.1) (2020-06-24)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/v7.1.0...v7.1.1)

## [v7.1.0](https://github.com/voxpupuli/puppet-cvmfs/tree/v7.1.0) (2020-06-24)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/v7.0.1...v7.1.0)

**Closed issues:**

- cvmfs-fsck.timer ist not enabled [\#99](https://github.com/voxpupuli/puppet-cvmfs/issues/99)
- Replace erwbgy/limits with actively maintained module [\#95](https://github.com/voxpupuli/puppet-cvmfs/issues/95)

**Merged pull requests:**

- New cvmfs\_instrument\_fuse parameter [\#102](https://github.com/voxpupuli/puppet-cvmfs/pull/102) ([traylenator](https://github.com/traylenator))
- Remove limits module and usage [\#101](https://github.com/voxpupuli/puppet-cvmfs/pull/101) ([traylenator](https://github.com/traylenator))
- cvmfs::fsck: Enable cvmfs-fsck.timer. [\#100](https://github.com/voxpupuli/puppet-cvmfs/pull/100) ([olifre](https://github.com/olifre))

## [v7.0.1](https://github.com/voxpupuli/puppet-cvmfs/tree/v7.0.1) (2020-02-10)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/v7.0.0...v7.0.1)

**Merged pull requests:**

- Drop files in autofs.master.d must end in .autofs [\#96](https://github.com/voxpupuli/puppet-cvmfs/pull/96) ([traylenator](https://github.com/traylenator))

## [v7.0.0](https://github.com/voxpupuli/puppet-cvmfs/tree/v7.0.0) (2020-01-06)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/v6.2.0...v7.0.0)

**Merged pull requests:**

- Remove SLC5 add C8 support [\#94](https://github.com/voxpupuli/puppet-cvmfs/pull/94) ([traylenator](https://github.com/traylenator))
- Correct cvmfs::cvmfs\_hash usage in example [\#93](https://github.com/voxpupuli/puppet-cvmfs/pull/93) ([traylenator](https://github.com/traylenator))
- add two optional parameters [\#92](https://github.com/voxpupuli/puppet-cvmfs/pull/92) ([Takadonet](https://github.com/Takadonet))
- cvmfs::fsck: Add ionice and a short sleep before fsck start. [\#91](https://github.com/voxpupuli/puppet-cvmfs/pull/91) ([olifre](https://github.com/olifre))
- yum: Allow to override includepkgs, default unchanged. [\#90](https://github.com/voxpupuli/puppet-cvmfs/pull/90) ([olifre](https://github.com/olifre))

## [v6.2.0](https://github.com/voxpupuli/puppet-cvmfs/tree/v6.2.0) (2019-03-14)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/v6.1.0...v6.2.0)

**Merged pull requests:**

- Forward CVMFS\_HTTP\_PROXY param to erb template [\#89](https://github.com/voxpupuli/puppet-cvmfs/pull/89) ([ebocchi](https://github.com/ebocchi))

## [v6.1.0](https://github.com/voxpupuli/puppet-cvmfs/tree/v6.1.0) (2019-01-28)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/v6.0.1...v6.1.0)

**Merged pull requests:**

- New cvmfs\_external\_ parameters [\#88](https://github.com/voxpupuli/puppet-cvmfs/pull/88) ([traylenator](https://github.com/traylenator))

## [v6.0.1](https://github.com/voxpupuli/puppet-cvmfs/tree/v6.0.1) (2018-12-03)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/6.0.0...v6.0.1)

## [6.0.0](https://github.com/voxpupuli/puppet-cvmfs/tree/6.0.0) (2018-12-03)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/v6.0.0...6.0.0)

## [v6.0.0](https://github.com/voxpupuli/puppet-cvmfs/tree/v6.0.0) (2018-12-03)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/5.2.0...v6.0.0)

**Closed issues:**

- cvmfs\_server\_url deprecation warning issues out of the box [\#83](https://github.com/voxpupuli/puppet-cvmfs/issues/83)

**Merged pull requests:**

- New dns\_min,max\_ttl variables [\#87](https://github.com/voxpupuli/puppet-cvmfs/pull/87) ([traylenator](https://github.com/traylenator))
- New yum\_priority parameter [\#86](https://github.com/voxpupuli/puppet-cvmfs/pull/86) ([traylenator](https://github.com/traylenator))
-  Modernise CERNOps-cvmfs module [\#85](https://github.com/voxpupuli/puppet-cvmfs/pull/85) ([traylenator](https://github.com/traylenator))

## [5.2.0](https://github.com/voxpupuli/puppet-cvmfs/tree/5.2.0) (2018-06-28)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/5.1.0...5.2.0)

**Closed issues:**

- Catalog timeouts mismatched with CVMFS default [\#81](https://github.com/voxpupuli/puppet-cvmfs/issues/81)

**Merged pull requests:**

- Fixes \#81 New mime\_expire parameter to stratum 1s [\#82](https://github.com/voxpupuli/puppet-cvmfs/pull/82) ([traylenator](https://github.com/traylenator))
- Add puppet 5 to tests [\#80](https://github.com/voxpupuli/puppet-cvmfs/pull/80) ([traylenator](https://github.com/traylenator))

## [5.1.0](https://github.com/voxpupuli/puppet-cvmfs/tree/5.1.0) (2018-06-28)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/5.0.0...5.1.0)

**Closed issues:**

- Strange set of options for tmpwatch [\#71](https://github.com/voxpupuli/puppet-cvmfs/issues/71)
- Default SELinux context is incorrect.  [\#68](https://github.com/voxpupuli/puppet-cvmfs/issues/68)
- non-existent option CVMFS\_FORCE\_SIGNING  is set automatically [\#66](https://github.com/voxpupuli/puppet-cvmfs/issues/66)
- CVMFS\_CLAIM\_OWNERSHIP for clients [\#62](https://github.com/voxpupuli/puppet-cvmfs/issues/62)
- Improve error message when running at CERN an pluginsync is in operation. [\#49](https://github.com/voxpupuli/puppet-cvmfs/issues/49)

**Merged pull requests:**

- Prepare 5.1.0 [\#79](https://github.com/voxpupuli/puppet-cvmfs/pull/79) ([traylenator](https://github.com/traylenator))
- Fixes \#66 drop CVMFS\_FORCE\_SIGNING [\#78](https://github.com/voxpupuli/puppet-cvmfs/pull/78) ([traylenator](https://github.com/traylenator))
- Fixes \#68 Correct selinux context for cache [\#77](https://github.com/voxpupuli/puppet-cvmfs/pull/77) ([traylenator](https://github.com/traylenator))
- Set catalog timeouts to 30s [\#76](https://github.com/voxpupuli/puppet-cvmfs/pull/76) ([traylenator](https://github.com/traylenator))
- clean\_quarantaine to check for directory existence [\#75](https://github.com/voxpupuli/puppet-cvmfs/pull/75) ([traylenator](https://github.com/traylenator))
- cmvfs::params: Remove hard abort on Debian. [\#74](https://github.com/voxpupuli/puppet-cvmfs/pull/74) ([olifre](https://github.com/olifre))
- fsck: Fix path for awk. [\#73](https://github.com/voxpupuli/puppet-cvmfs/pull/73) ([olifre](https://github.com/olifre))
- cvmfs::fsck: tmpwatch on RedHat, tmpreaper on Debian. [\#72](https://github.com/voxpupuli/puppet-cvmfs/pull/72) ([olifre](https://github.com/olifre))
- Do not disable SELinux for Stratum 0 / Stratum 1. [\#70](https://github.com/voxpupuli/puppet-cvmfs/pull/70) ([olifre](https://github.com/olifre))
- Prepare 5.0.0 [\#69](https://github.com/voxpupuli/puppet-cvmfs/pull/69) ([traylenator](https://github.com/traylenator))

## [5.0.0](https://github.com/voxpupuli/puppet-cvmfs/tree/5.0.0) (2018-01-24)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/4.2.0...5.0.0)

**Merged pull requests:**

- Deprecate all explicit hiera calls in params.pp [\#34](https://github.com/voxpupuli/puppet-cvmfs/pull/34) ([traylenator](https://github.com/traylenator))

## [4.2.0](https://github.com/voxpupuli/puppet-cvmfs/tree/4.2.0) (2017-05-18)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/4.1.0...4.2.0)

**Merged pull requests:**

- New expireation timeout paramter for stratum zero parameters  [\#65](https://github.com/voxpupuli/puppet-cvmfs/pull/65) ([traylenator](https://github.com/traylenator))
- Use a puppet3 supporting concat version [\#64](https://github.com/voxpupuli/puppet-cvmfs/pull/64) ([traylenator](https://github.com/traylenator))
- added cvmfs\_claim\_ownership for the client configuration [\#63](https://github.com/voxpupuli/puppet-cvmfs/pull/63) ([mboisson](https://github.com/mboisson))

## [4.1.0](https://github.com/voxpupuli/puppet-cvmfs/tree/4.1.0) (2017-04-04)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-4.0.0...4.1.0)

**Merged pull requests:**

- New parameter cvmfs\_memcache\_size [\#61](https://github.com/voxpupuli/puppet-cvmfs/pull/61) ([traylenator](https://github.com/traylenator))

## [puppet-cvmfs-4.0.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-4.0.0) (2017-02-15)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-3.2.0...puppet-cvmfs-4.0.0)

## [puppet-cvmfs-3.2.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-3.2.0) (2017-02-08)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-3.1.0...puppet-cvmfs-3.2.0)

**Merged pull requests:**

- Dan's commits CERN [\#60](https://github.com/voxpupuli/puppet-cvmfs/pull/60) ([traylenator](https://github.com/traylenator))
- Purge config.d directory [\#59](https://github.com/voxpupuli/puppet-cvmfs/pull/59) ([rwf14f](https://github.com/rwf14f))
- Bug, do not require yumrepo if not included [\#58](https://github.com/voxpupuli/puppet-cvmfs/pull/58) ([traylenator](https://github.com/traylenator))

## [puppet-cvmfs-3.1.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-3.1.0) (2016-09-14)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-3.0.1...puppet-cvmfs-3.1.0)

## [puppet-cvmfs-3.0.1](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-3.0.1) (2016-08-18)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-3.0.0...puppet-cvmfs-3.0.1)

## [puppet-cvmfs-3.0.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-3.0.0) (2016-08-18)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-2.0.0...puppet-cvmfs-3.0.0)

**Closed issues:**

- Missing packages/hidden dependency? [\#56](https://github.com/voxpupuli/puppet-cvmfs/issues/56)
- cvmfs::one::install does not inherit any params. [\#53](https://github.com/voxpupuli/puppet-cvmfs/issues/53)
- Drop autofs lens [\#51](https://github.com/voxpupuli/puppet-cvmfs/issues/51)
- Drop cvmfs 2.0 support [\#50](https://github.com/voxpupuli/puppet-cvmfs/issues/50)
- Support fstab entry for cvmfs mounts. [\#41](https://github.com/voxpupuli/puppet-cvmfs/issues/41)

## [puppet-cvmfs-2.0.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-2.0.0) (2016-04-29)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-1.0.3...puppet-cvmfs-2.0.0)

**Merged pull requests:**

- Drop cmvfs 2.0.x support  [\#52](https://github.com/voxpupuli/puppet-cvmfs/pull/52) ([arbreezy](https://github.com/arbreezy))

## [puppet-cvmfs-1.0.3](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-1.0.3) (2016-03-14)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cmvfs-1.0.2...puppet-cvmfs-1.0.3)

**Merged pull requests:**

- one: sync in parallel at 15 minute intervals [\#48](https://github.com/voxpupuli/puppet-cvmfs/pull/48) ([dvanders](https://github.com/dvanders))

## [puppet-cmvfs-1.0.2](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cmvfs-1.0.2) (2016-03-07)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-1.0.1...puppet-cmvfs-1.0.2)

## [puppet-cvmfs-1.0.1](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-1.0.1) (2016-03-04)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cmvfs-1.0.0...puppet-cvmfs-1.0.1)

## [puppet-cmvfs-1.0.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cmvfs-1.0.0) (2016-03-04)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.9.0...puppet-cmvfs-1.0.0)

**Closed issues:**

- Configuration never taking place [\#44](https://github.com/voxpupuli/puppet-cvmfs/issues/44)

**Merged pull requests:**

- The operatingsytem fact must be set. [\#47](https://github.com/voxpupuli/puppet-cvmfs/pull/47) ([traylenator](https://github.com/traylenator))
- New stratum 0 options for cvmfs 2.2. [\#46](https://github.com/voxpupuli/puppet-cvmfs/pull/46) ([traylenator](https://github.com/traylenator))
- use ensure\_packages to avoid "redef errors" [\#45](https://github.com/voxpupuli/puppet-cvmfs/pull/45) ([jcpunk](https://github.com/jcpunk))
- cvmf::install: allow to disable yum repository management [\#43](https://github.com/voxpupuli/puppet-cvmfs/pull/43) ([gwarf](https://github.com/gwarf))
- Run acceptence tests on travis docker [\#42](https://github.com/voxpupuli/puppet-cvmfs/pull/42) ([traylenator](https://github.com/traylenator))

## [puppet-cvmfs-0.9.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.9.0) (2015-08-04)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.8.1...puppet-cvmfs-0.9.0)

**Closed issues:**

- typo in $cvmfs\_yum\_testing\_enabled parameter in init.pp [\#40](https://github.com/voxpupuli/puppet-cvmfs/issues/40)
- coveralls.io support? [\#25](https://github.com/voxpupuli/puppet-cvmfs/issues/25)

**Merged pull requests:**

- Additional option CVMFS\_MOUNT\_RW in repo.local template. [\#36](https://github.com/voxpupuli/puppet-cvmfs/pull/36) ([mrolli](https://github.com/mrolli))

## [puppet-cvmfs-0.8.1](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.8.1) (2015-07-07)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.8.0...puppet-cvmfs-0.8.1)

## [puppet-cvmfs-0.8.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.8.0) (2015-07-07)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.7.0...puppet-cvmfs-0.8.0)

**Closed issues:**

- CVMFS\_FOLLOW\_REDIRECTS=yes [\#39](https://github.com/voxpupuli/puppet-cvmfs/issues/39)

## [puppet-cvmfs-0.7.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.7.0) (2015-06-22)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.6.0...puppet-cvmfs-0.7.0)

## [puppet-cvmfs-0.6.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.6.0) (2015-06-10)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.5.0...puppet-cvmfs-0.6.0)

**Closed issues:**

- CVMFS\_IGNORE\_XDIR\_HARDLINKS=true [\#38](https://github.com/voxpupuli/puppet-cvmfs/issues/38)

**Merged pull requests:**

- Fixed package names in dependency list. [\#37](https://github.com/voxpupuli/puppet-cvmfs/pull/37) ([mrolli](https://github.com/mrolli))
- README.md has drifted abit from the current feature set of init.pp [\#35](https://github.com/voxpupuli/puppet-cvmfs/pull/35) ([jcpunk](https://github.com/jcpunk))

## [puppet-cvmfs-0.5.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.5.0) (2015-05-06)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.4.4...puppet-cvmfs-0.5.0)

**Closed issues:**

- Client configuration in README.md provides invalid example [\#28](https://github.com/voxpupuli/puppet-cvmfs/issues/28)

**Merged pull requests:**

- Fixes \#28 - Readme examples should now all work. [\#33](https://github.com/voxpupuli/puppet-cvmfs/pull/33) ([traylenator](https://github.com/traylenator))
- Simple ls /cvmfs/atlas.cern.ch/repo as first acceptence test' [\#32](https://github.com/voxpupuli/puppet-cvmfs/pull/32) ([traylenator](https://github.com/traylenator))
- Notice seems a bit low for these messages [\#31](https://github.com/voxpupuli/puppet-cvmfs/pull/31) ([jcpunk](https://github.com/jcpunk))
- I've configured this module to point to OSG cvmfs package, but can't install them [\#30](https://github.com/voxpupuli/puppet-cvmfs/pull/30) ([jcpunk](https://github.com/jcpunk))
- List other OS platforms this works on [\#27](https://github.com/voxpupuli/puppet-cvmfs/pull/27) ([jcpunk](https://github.com/jcpunk))

## [puppet-cvmfs-0.4.4](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.4.4) (2015-04-30)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.4.3...puppet-cvmfs-0.4.4)

**Closed issues:**

- v0.4.3 unable to resolve dependency 'erwbgy-limits' \(\>=1.0.0\) [\#26](https://github.com/voxpupuli/puppet-cvmfs/issues/26)

## [puppet-cvmfs-0.4.3](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.4.3) (2015-04-30)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.4.2...puppet-cvmfs-0.4.3)

## [puppet-cvmfs-0.4.2](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.4.2) (2015-04-30)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.4.1...puppet-cvmfs-0.4.2)

## [puppet-cvmfs-0.4.1](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.4.1) (2015-04-29)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.4.0...puppet-cvmfs-0.4.1)

**Closed issues:**

- hiera\('key',undef\) Incompatible with future parser. [\#19](https://github.com/voxpupuli/puppet-cvmfs/issues/19)

## [puppet-cvmfs-0.4.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.4.0) (2015-04-29)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.3.3...puppet-cvmfs-0.4.0)

**Closed issues:**

- cvmfs\_env\_variables for default.local [\#23](https://github.com/voxpupuli/puppet-cvmfs/issues/23)
- autofs management is all or nothing [\#20](https://github.com/voxpupuli/puppet-cvmfs/issues/20)
- cvmfs::mount type should support cvmfs\_http\_proxy option. [\#15](https://github.com/voxpupuli/puppet-cvmfs/issues/15)

**Merged pull requests:**

- Allow service to be managed seperately [\#21](https://github.com/voxpupuli/puppet-cvmfs/pull/21) ([jcpunk](https://github.com/jcpunk))
- Remove concat setup dependency [\#18](https://github.com/voxpupuli/puppet-cvmfs/pull/18) ([berghaus](https://github.com/berghaus))
- Allow cvmfs-config package to be installed [\#17](https://github.com/voxpupuli/puppet-cvmfs/pull/17) ([traylenator](https://github.com/traylenator))

## [puppet-cvmfs-0.3.3](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.3.3) (2015-03-06)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.3.2...puppet-cvmfs-0.3.3)

**Merged pull requests:**

- yum proxy and checking autofs  [\#16](https://github.com/voxpupuli/puppet-cvmfs/pull/16) ([fmelaccio](https://github.com/fmelaccio))

## [puppet-cvmfs-0.3.2](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.3.2) (2014-06-18)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cmvfs-0.3.1...puppet-cvmfs-0.3.2)

## [puppet-cmvfs-0.3.1](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cmvfs-0.3.1) (2014-06-18)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.2.2...puppet-cmvfs-0.3.1)

**Closed issues:**

- module with 'domain' settings? [\#14](https://github.com/voxpupuli/puppet-cvmfs/issues/14)

## [puppet-cvmfs-0.2.2](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.2.2) (2014-03-27)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.2.1...puppet-cvmfs-0.2.2)

**Merged pull requests:**

- fixed cvmfs\_public\_key name in template [\#13](https://github.com/voxpupuli/puppet-cvmfs/pull/13) ([rwf14f](https://github.com/rwf14f))

## [puppet-cvmfs-0.2.1](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.2.1) (2014-01-16)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.2.0...puppet-cvmfs-0.2.1)

## [puppet-cvmfs-0.2.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.2.0) (2013-12-09)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.1.0...puppet-cvmfs-0.2.0)

## [puppet-cvmfs-0.1.0](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.1.0) (2013-12-04)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.0.2...puppet-cvmfs-0.1.0)

**Closed issues:**

- How to include CMS\_LOCAL\_SITE [\#8](https://github.com/voxpupuli/puppet-cvmfs/issues/8)
- few typos [\#6](https://github.com/voxpupuli/puppet-cvmfs/issues/6)

**Merged pull requests:**

- Add stratum 0 and stratum 1 support. [\#12](https://github.com/voxpupuli/puppet-cvmfs/pull/12) ([traylenator](https://github.com/traylenator))
- Add cvmfs\_server 2.1 support [\#11](https://github.com/voxpupuli/puppet-cvmfs/pull/11) ([traylenator](https://github.com/traylenator))
- Confine cvmfspartsize fact to Linux kernel [\#10](https://github.com/voxpupuli/puppet-cvmfs/pull/10) ([luisfdez](https://github.com/luisfdez))
- Adding environmental variables to CVMFS config [\#9](https://github.com/voxpupuli/puppet-cvmfs/pull/9) ([kreczko](https://github.com/kreczko))
- Move yumrepos to seperate file to install.pp to allow cvmfs::server to reuse yumrepos. [\#7](https://github.com/voxpupuli/puppet-cvmfs/pull/7) ([traylenator](https://github.com/traylenator))
- Tidying up meta data [\#5](https://github.com/voxpupuli/puppet-cvmfs/pull/5) ([kreczko](https://github.com/kreczko))
- cvmfs 2.1 really is supported now. [\#3](https://github.com/voxpupuli/puppet-cvmfs/pull/3) ([traylenator](https://github.com/traylenator))
- Module update + fixes [\#2](https://github.com/voxpupuli/puppet-cvmfs/pull/2) ([kreczko](https://github.com/kreczko))
- text fixes [\#1](https://github.com/voxpupuli/puppet-cvmfs/pull/1) ([deesto](https://github.com/deesto))

## [puppet-cvmfs-0.0.2](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.0.2) (2013-03-18)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/puppet-cvmfs-0.0.1...puppet-cvmfs-0.0.2)

## [puppet-cvmfs-0.0.1](https://github.com/voxpupuli/puppet-cvmfs/tree/puppet-cvmfs-0.0.1) (2012-06-01)

[Full Changelog](https://github.com/voxpupuli/puppet-cvmfs/compare/334613ae5fb3778beb132cb05ad6fd6b28ff1c02...puppet-cvmfs-0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
