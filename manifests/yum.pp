# @summary Configure cvmfs yum repositories
# @api private
#
class cvmfs::yum (
  Stdlib::Httpurl $repo_base                                            = $cvmfs::repo_base,
  Stdlib::Httpurl $repo_base_alt                                        = $cvmfs::repo_base_alt,
  Stdlib::Httpurl $repo_gpgkey                                          = $cvmfs::repo_gpgkey,
  Integer $repo_priority                                                = $cvmfs::repo_priority,
  Boolean $repo_config_enabled                                          = $cvmfs::repo_config_enabled,
  Boolean $repo_testing_enabled                                         = $cvmfs::repo_testing_enabled,
  Boolean $repo_future_enabled                                          = $cvmfs::repo_future_enabled,
  Optional[Stdlib::Httpurl] $repo_proxy                                 = $cvmfs::repo_proxy,
  Boolean $repo_gpgcheck                                                = $cvmfs::repo_gpgcheck,
  Optional[Variant[Enum['absent'], Array[String[1]]]] $repo_includepkgs = $cvmfs::repo_includepkgs,

)  inherits cvmfs {
  if $repo_includepkgs =~ Array[String] {
    $_yum_includepkgs = join($repo_includepkgs, ' ')
  } else {
    $_yum_includepkgs = $repo_includepkgs
  }

  Yumrepo {
    gpgcheck    => $repo_gpgcheck,
    gpgkey      => $repo_gpgkey,
    includepkgs => $_yum_includepkgs,
    priority    => $repo_priority,
    proxy       => $repo_proxy,
  }

  $_dir = $facts['os']['name'] ? {
    'Fedora' => 'fedora',
    default  => 'EL'
  }

  yumrepo { 'cvmfs':
    descr   => "CVMFS yum repository for ${_dir}${facts['os']['release']['major']}",
    baseurl => "${repo_base}/cvmfs/${_dir}/${facts['os']['release']['major']}/${facts['os']['architecture']}",
    enabled => true,
  }

  yumrepo { 'cvmfs-testing':
    descr   => "CVMFS-testing yum repository for ${_dir}${facts['os']['release']['major']}. Same binaries as production repo, released earlier. Very stable.",
    baseurl => "${repo_base}/cvmfs-testing/${_dir}/${facts['os']['release']['major']}/${facts['os']['architecture']}",
    enabled => $repo_testing_enabled,
  }

  yumrepo { 'cvmfs-future':
    descr   => "CVMFS-future yum repository for ${_dir}${facts['os']['release']['major']}. Tagged pre-releases. Stable.",
    # note the use of repo_base_alt - this is in principle a mirror of repo_base, but prereleases are published there first
    baseurl => "${repo_base_alt}/cvmfs-future/${_dir}/${facts['os']['release']['major']}/${facts['os']['architecture']}",
    enabled => $repo_future_enabled,
  }

  yumrepo { 'cvmfs-config':
    descr   => "CVMFS config yum repository for ${_dir}${facts['os']['release']['major']}",
    baseurl => "${repo_base}/cvmfs-config/${_dir}/${facts['os']['release']['major']}/${facts['os']['architecture']}",
    enabled => $repo_config_enabled,
  }
}
