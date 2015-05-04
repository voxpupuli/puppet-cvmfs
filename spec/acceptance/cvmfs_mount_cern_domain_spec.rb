require 'spec_helper_acceptance'

describe 'cvmfs::domain cern.ch' do
    it 'should configure and work with no errors' do
      pp = <<-EOS
         class{"cvmfs":
             cvmfs_http_proxy => 'http://ca-proxy.cern.ch:3128;DIRECT',
         }
         cvmfs::domain{'cern.ch':
            cvmfs_server_url =>  'http://cvmfs-stratum-one.cern.ch/cvmfs/@fqrn@'
         }
      EOS
      # Run it three times, it should be stable by then
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
      # The automounter can retrun before it is actually working.
      shell('sleep 10')
      shell('ls /cvmfs/cms.cern.ch',  :acceptable_exit_codes => 0)
    end
end
