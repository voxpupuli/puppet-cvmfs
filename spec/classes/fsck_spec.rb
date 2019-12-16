require 'spec_helper'
describe 'cvmfs::fsck' do
  let(:pre_condition) do
    'class{cvmfs: cvmfs_http_proxy => undef}'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      context "with defaults" do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/usr/local/sbin/cvmfs_fsck_cron.sh').with_content(%r{\s* nice ionice -c3 /usr/bin/cvmfs_fsck  /var/lib/cvmfs/shared$})}
        it { is_expected.to contain_cron('clean_quarantaine') }
        it { is_expected.to contain_cron('cvmfs_fsck') }
        it { is_expected.not_to contain_cron('cvmfs_fsck_on_reboot') }
      end
      context 'with booleans true' do
        let(:params) do {
          onreboot: true
        }
        end
        it { is_expected.to contain_cron('cvmfs_fsck_on_reboot') }
      end
      context 'with booleans false' do
        let(:params) do {
          onreboot: false
        }
        end
        it { is_expected.not_to contain_cron('cvmfs_fsck_on_reboot') }
      end
    end
  end
end
