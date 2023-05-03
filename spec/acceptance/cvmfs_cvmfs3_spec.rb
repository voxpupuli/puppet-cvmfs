# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'cvmfs::domain cern.ch' do
  it 'configures and work with no errors' do
    skip('Fuse3 impossible on Ubuntu 18.04, will EOL June 2023') if (fact('os.name') == 'Ubuntu') && (fact('os.release.major') == '18.04')
    # Clean up all existing mounts
    shell('cvmfs_config killall', acceptable_exit_codes: [0, 127])
    pp = <<-EOS
         class{"cvmfs":
             cvmfs_http_proxy => 'http://ca-proxy.cern.ch:3128;DIRECT',
             fuse3            => true,
         }
         cvmfs::domain{'cern.ch':
            cvmfs_server_url =>  'http://cvmfs-stratum-one.cern.ch/cvmfs/@fqrn@'
         }
    EOS
    # Run it three times, it should be stable by then
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
    # The automounter can retrun before it is actually working.
    shell('sleep 10')
    shell('ls /cvmfs/cms.cern.ch', acceptable_exit_codes: 0)
  end

  describe package('cvmfs-fuse3') do
    it {
      skip('Fuse3 impossible on Ubuntu 18.04, will be EOL June 2023') if (fact('os.name') == 'Ubuntu') && (fact('os.release.major') == '18.04')
      is_expected.to be_installed
    }
  end
end
