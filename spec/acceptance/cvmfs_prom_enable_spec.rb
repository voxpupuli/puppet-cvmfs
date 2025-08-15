# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'cvmfs enable_prometheus_exporter' do
  it 'configures and work with no errors' do
    # Clean up all existing mounts
    shell('cvmfs_config killall', acceptable_exit_codes: [0, 127])
    pp = <<-PUPPET
         class{ 'cvmfs':
           cvmfs_http_proxy           => 'http://ca-proxy.cern.ch:3128;DIRECT',
           enable_prometheus_exporter => true,
         }
         cvmfs::domain{ 'cern.ch':
          cvmfs_server_url =>  'http://cvmfs-stratum-one.cern.ch/cvmfs/@fqrn@'
         }
    PUPPET
    # Run it three times, it should be stable by then
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
    # The automounter can retrun before it is actually working.
    shell('sleep 10')
    shell('ls /cvmfs/cms.cern.ch', acceptable_exit_codes: 0)
  end

  describe service('cvmfs-client-prometheus.socket') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port('9868') do
    it { is_expected.to be_listening }
  end

  describe command('curl -s http://localhost:9868/metrics') do
    its(:stdout) { is_expected.to match(%r{^# HELP}) }
  end
end
