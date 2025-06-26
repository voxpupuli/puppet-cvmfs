# @api private
#
# @summary enable check_fsck as a cron or systemd timer
#
# @param cvmfs_cache_base Root of cvmfs cache
# @param options Any extra options
# @param onreboot Should fsck be run after every reboot
#
class cvmfs::fsck (
  Stdlib::Absolutepath $cvmfs_cache_base = $cvmfs::cvmfs_cache_base,
  Optional[String] $options = $cvmfs::cvmfs_fsck_options,
  Boolean $onreboot = $cvmfs::cvmfs_fsck_onreboot,
) inherits cvmfs {
  systemd::timer { 'cvmfs-fsck.timer':
    service_content => epp('cvmfs/fsck/cvmfs-fsck.service.epp',
      {
        'cache_base' => $cvmfs_cache_base,
        'options'    => $options,
    }),
    timer_content   => epp('cvmfs/fsck/cvmfs-fsck.timer.epp',
      {
        'onreboot' => $onreboot,
    }),
    enable          => true,
    active          => true,
  }

  # This removal of a now redundant can be removed at some future date
  systemd::tmpfile { 'cvmfs-quarantaine.conf':
    ensure => absent,
  }
}
