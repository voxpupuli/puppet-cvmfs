# @summary Manages the cvmfs services.
# @api private
#
class cvmfs::service (
  Boolean $enable_prometheus_exporter = $cvmfs::enable_prometheus_exporter,
  Boolean $use_config_reload = $cvmfs::use_config_reload,
) inherits cvmfs {
  $_reload_command = $use_config_reload ? {
    true    => '/usr/bin/cvmfs_config reload',
    default => '/usr/bin/systemctl start cvmfs-reload.service',
  }

  exec { 'Reloading cvmfs':
    command     => $_reload_command,
    refreshonly => true,
  }

  service { 'cvmfs-client-prometheus.socket':
    ensure => $enable_prometheus_exporter,
    enable => $enable_prometheus_exporter,
  }
}
