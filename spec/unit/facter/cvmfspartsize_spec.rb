# frozen_string_literal: true

require 'spec_helper'

describe 'cvmfspartsize' do
  before do
    Facter.clear
    allow(Facter::Util::Resolution).to receive(:which).with('df').and_return('/usr/bin/df')
    allow(File).to receive(:exist?).with('/etc/cvmfs/cvmfsfacts.yaml').and_return(true)
    allow(File).to receive(:open).with('/etc/cvmfs/cvmfsfacts.yaml').and_return("---\ncvmfs_cache_base: /foo/bar\n")
    allow(Facter::Core::Execution).to receive(:execute).with('/usr/bin/df -m -P /foo/bar').and_return(cvmfs_df_result)
  end

  context 'working case' do
    before do
      allow(File).to receive(:exist?).with('/foo/bar').and_return(true)
    end

    let(:cvmfs_df_result) { "/dev/nvme0n1p5            976   251       659      28% /foo/bar\n" }

    it 'returns valid fact' do
      expect(Facter.fact('cvmfspartsize').value).to eq(976)
    end
  end

  context 'config missing' do
    let(:cvmfs_df_result) { :failed }

    it 'does not return a fact' do
      allow(File).to receive(:exist?).with('/etc/cvmfs/cvmfsfacts.yaml').and_return(false)
      expect(Facter.fact('cvmfspartsize').value).to be_nil
    end
  end

  context 'df fails' do
    before do
      allow(File).to receive(:exist?).with('/foo/bar').and_return(false)
    end

    let(:cvmfs_df_result) { :failed }

    it 'does not return a fact' do
      allow(Facter::Core::Execution).to receive(:execute).with('/usr/bin/df -m -P /foo/bar').and_return(:failed)
      expect(Facter.fact('cvmfspartsize').value).to be_nil
    end
  end
end
