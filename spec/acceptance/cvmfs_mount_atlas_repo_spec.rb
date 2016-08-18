require 'spec_helper_acceptance'

describe 'cvmfs::mount atlas.cern.ch' do
  it 'configures and work with no errors' do
    pp = <<-EOS
         class{"cvmfs":
             cvmfs_http_proxy => 'http://ca-proxy.cern.ch:3128;DIRECT',
         }
         cvmfs::mount{'atlas.cern.ch':
            cvmfs_server_url =>  'http://cvmfs-stratum-one.cern.ch/cvmfs/atlas.cern.ch'
         }
      EOS
    # Run it three times, it should be stable by then
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
    # The automounter can retrun before it is actually working.
    shell('sleep 10')
    shell('ls /cvmfs/atlas.cern.ch/repo', acceptable_exit_codes: 0)
  end
end
