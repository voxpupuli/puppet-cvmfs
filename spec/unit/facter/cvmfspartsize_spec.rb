require 'spec_helper'

describe 'cvmfspartsize' do
  before do
    Facter.clear
    Facter::Util::Resolution.stubs(:which).with('df').returns('/usr/bin/df')
    File.stubs(:exist?).with('/etc/cvmfs/cvmfsfacts.yaml').returns(true)
    File.stubs(:open).with('/etc/cvmfs/cvmfsfacts.yaml').returns("---\ncvmfs_cache_base: /foo/bar\n")
    Facter::Core::Execution.stubs(:execute).with('/usr/bin/df -m -P /foo/bar').returns(cvmfs_df_result)
  end

  context 'working case' do
    let(:cvmfs_df_result) { "/dev/nvme0n1p5            976   251       659      28% /foo/bar\n" }

    it 'returns valid fact' do
      expect(Facter.fact('cvmfspartsize').value).to eq(976)
    end
  end

  context 'config missing' do
    let(:cvmfs_df_result) { :failed }

    it 'does not return a fact' do
      File.stubs(:exist?).with('/etc/cvmfs/cvmfsfacts.yaml').returns(false)
      expect(Facter.fact('cvmfspartsize').value).to be_nil
    end
  end

  context 'df fails' do
    let(:cvmfs_df_result) { :failed }

    it 'does not return a fact' do
      Facter::Core::Execution.stubs(:execute).with('/usr/bin/df -m -P /foo/bar').returns(:failed)
      expect(Facter.fact('cvmfspartsize').value).to be_nil
    end
  end
end
