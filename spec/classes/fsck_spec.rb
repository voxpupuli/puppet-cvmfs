# frozen_string_literal: true

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

      context 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_cron('cvmfs_fsck_on_reboot') }

        it { is_expected.not_to contain_file('/usr/local/sbin/cvmfs_fsck_cron.sh') }
        it { is_expected.not_to contain_cron('clean_quarantaine') }
        it { is_expected.not_to contain_cron('cvmfs_fsck') }
        it { is_expected.to contain_systemd__tmpfile('cvmfs-quarantaine.conf').with_ensure('absent') }

        it {
          is_expected.to contain_systemd__timer('cvmfs-fsck.timer').
            with_service_content(%r{^ExecStart=/usr/bin/cvmfs_fsck  /var/lib/cvmfs/shared$}).
            with_service_content(%r{^ConditionPathExists=/var/lib/cvmfs/shared/txn$}).
            with_service_content(%r{^User=cvmfs$}).
            with_timer_content(%r{^OnUnitActiveSec=1week$}).
            without_timer_content(%r{^OnBootSec$})
        }
      end

      context 'with onreboot true' do
        let(:params) do
          {
            onreboot: true
          }
        end

        it { is_expected.not_to contain_cron('cvmfs_fsck_on_reboot') }
        it { is_expected.to contain_systemd__timer('cvmfs-fsck.timer').with_timer_content(%r{^OnBootSec=5min$}) }
      end

      context 'with onreboot false' do
        let(:params) do
          {
            onreboot: false
          }
        end

        it { is_expected.to contain_systemd__timer('cvmfs-fsck.timer').with_timer_content(%r{^OnUnitActiveSec=1week$}) }
      end

      context 'with options set' do
        let(:params) do
          {
            options: '-p',
            cvmfs_cache_base: '/foo'
          }
        end

        it { is_expected.to contain_systemd__timer('cvmfs-fsck.timer').with_service_content(%r{^ExecStart=/usr/bin/cvmfs_fsck -p /foo/shared$}) }
        it { is_expected.to contain_systemd__timer('cvmfs-fsck.timer').with_service_content(%r{^ConditionPathExists=/foo/shared/txn$}) }
      end
    end
  end
end
