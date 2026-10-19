# @summary Manages the autofs integration for CVMFS.
#
# Delegates all autofs management (package, service and master map) to the
# autofs module and declares the `/cvmfs` automount entry as `autofs::mount`.
# cvmfs no longer manages the autofs service or its own drop-in map file.
#
# @param mount_method See cvmfs. Determines whether autofs is used.
# @param manage_autofs_service See cvmfs. Controls whether the autofs module is declared.
#
# @api private
#
class cvmfs::autofs (
  Enum['autofs','mount','none'] $mount_method = $cvmfs::mount_method,
  Boolean $manage_autofs_service = $cvmfs::manage_autofs_service,
) inherits cvmfs {
  if $manage_autofs_service and $mount_method == 'autofs' {
    contain 'autofs'

    autofs::mount { 'cvmfs':
      mount   => '/cvmfs',
      mapfile => 'program:/etc/auto.cvmfs',
      use_dir => true,
    }
  }
}
