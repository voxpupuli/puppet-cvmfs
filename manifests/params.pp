class cvmfs::params {

    # For now just check os and cvmfsversion and exit if it untested.
    # in time we can different parameters for each of these conditions.
    if $::osfamily == 'RedHat' and $::operatingsystem == 'Fedora' {
         fail('This cvmfs module has not been verified under fedora.')
    } elsif $::osfamily != 'RedHat' {
         fail('This cvmfs module has not been verified under osfamily other than RedHat')
    }

    # This cvmfs module will also configure autofs as well for use
    # by cvmfs. If you are managing autofs elsewhere set to false.
    # This being the string 'true' and not boolean true is a hiera bug.
    $config_automaster      = hiera('cvmfs_config_automaster','true')

    # Server configuration is not supported yet, just a place holder
    # for when it is supported. These options currently do nothing.
    $config_client          = true
    $config_server          = false

    # cvmfs_quota_limit are all destined for /etc/cvmfs/default.local
    # and provide defaults for all cvmfs repositories.
    # So if 2.0 this quota per repository but for 2.1 it is the total
    # shared repository.
    # cvmfs_quota_limit can be set to 'auto' and in which case the fact
    # $::cvmfscachepart is also used to set the CACHE size to 90% of
    # the partition size. So setting this with cvmfs 2.0 is completly
    # insane and setting it when you have not allocated a dedicated
    # partition for CVMFS is also insane.
    $my_cvmfs_quota_limit      = hiera('cvmfs_quota_limit','20000')
    if $my_cvmfs_quota_limit == 'auto' and $::cvmfscachepart {
       $cvmfs_quota_limit = sprintf('%i',0.9 *  $::cvmfscachepart)
    } else {
       $cvmfs_quota_limit = $my_cvmfs_quota_limit
    }

    $cvmfs_http_proxy       = hiera('cvmfs_http_proxy','http://squid.example.org:3128')
    $cvmfs_server_url       = hiera('cvmfs_server_url','http://web.example.org:80/opt/example')
    $cvmfs_cache_base       = hiera('cvmfs_cache_base',undef)
    $cvmfs_timeout          = hiera('cvmfs_timeout',undef)
    $cvmfs_timeout_direct   = hiera('cvmfs_timeout',undef)
    $cvmfs_nfiles           = hiera('cvmfs_nfiles',undef)
    $cvmfs_public_key       = hiera('cvmfs_public_key',undef)
    $cvmfs_force_signing    = hiera('cvmfs_force_signing','yes')
    $cvmfs_syslog_level     = hiera('cvmfs_syslog_level',undef)
    $cvmfs_tracefile        = hiera('cvmfs_tracefile',undef)
    $cvmfs_debuglog         = hiera('cvmfs_debuglog',undef)
    $cvmfs_max_ttl          = hiera('cvmfs_max_ttl',undef)
    $cvmfs_hash             = hiera('cvmfs::mount',undef)

    # The version of cvmfs to install, should be present and latest,
    # or an exact version number of the package.
    $major_release = regsubst($::operatingsystemrelease,'^(\d+)\.\d+$','\1')
    $cvmfs_version          = hiera('cvmfsversion','present')
    $cvmfs_yum              = hiera('cvmfs_yum',"http://cern.ch/cvmrepo/yum/cvmfs/EL/${major_release}/${architecture}")
    $cvmfs_yum_testing      = hiera('cvmfs_yum',"http://cern.ch/cvmrepo/yum/cvmfs-testing/EL/${major_release}/${architecture}")
    $cvmfs_yum_testing_enabled = hiera('cvmfs_yum_testing_enabled','0')
}
