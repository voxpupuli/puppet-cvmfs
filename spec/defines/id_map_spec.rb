require 'spec_helper'

describe 'cvmfs::id_map' do
  let(:pre_condition) do
    'class{"cvmfs": cvmfs_http_proxy => undef}'
  end
  let(:title) { '/etc/cvmfs/config.d/files.example.org.uid_map' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with a single mapping set' do
        let(:params) { { map: { 123 => 12 } } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.uid_map').with('content' => "# Created by puppet.\n123 12\n") }
      end

      context 'with multiple mappings set' do
        let(:params) { { map: { 123 => 12, 137 => 42 } } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.uid_map').with('content' => "# Created by puppet.\n123 12\n137 42\n") }
      end

      context 'with any-mapping set' do
        let(:params) { { map: { '*' => 42 } } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.uid_map').with('content' => "# Created by puppet.\n* 42\n") }
      end
    end
  end
end
