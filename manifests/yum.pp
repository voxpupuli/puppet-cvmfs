# @summary Configure cvmfs yum repositories
# @api private
#
class cvmfs::yum (
  Stdlib::Httpurl $repo_base                                            = $cvmfs::repo_base,
  Stdlib::Httpurl $repo_gpgkey                                          = $cvmfs::repo_gpgkey,
  Integer $repo_priority                                                = $cvmfs::repo_priority,
  Boolean $repo_config_enabled                                          = $cvmfs::repo_config_enabled,
  Boolean $repo_testing_enabled                                         = $cvmfs::repo_testing_enabled,
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

  yumrepo { 'cvmfs':
    descr   => "CVMFS yum repository for el${facts['os']['release']['major']}",
    baseurl => "${repo_base}/cvmfs/EL/${facts['os']['release']['major']}/${facts['os']['architecture']}",
    enabled => true,
  }

  yumrepo { 'cvmfs-testing':
    descr   => "CVMFS yum testing repository for el${facts['os']['release']['major']}",
    baseurl => "${repo_base}/cvmfs-testing/EL/${facts['os']['release']['major']}/${facts['os']['architecture']}",
    enabled => $repo_testing_enabled,
  }

  yumrepo { 'cvmfs-config':
    descr   => "CVMFS config yum repository for el${facts['os']['release']['major']}",
    baseurl => "${repo_base}/cvmfs-config/EL/${facts['os']['release']['major']}/${facts['os']['architecture']}",
    enabled => $repo_config_enabled,
  }
}
