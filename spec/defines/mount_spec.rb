# frozen_string_literal: true

require 'spec_helper'

describe 'cvmfs::mount' do
  let(:title) { 'files.example.org' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:pre_condition) do
        ['class{"cvmfs": cvmfs_http_proxy => undef}']
      end

      let(:facts) do
        facts
      end

      context 'with and cvmfspartsize fact set' do
        let(:facts) do
          facts.merge(cvmfspartsize: '10000000')
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local') }

        it {
          is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').
            without_content(%r{.*CVMFS_MEMCACHE_SIZE.*$}).
            without_content(%r{.*CVMFS_USE_GEOAPI.*$}).
            without_content(%r{.*CVMFS_FOLLOW_REDIRECTS.*$}).
            without_content(%r{.*CVMFS_CLAIM_OWNERSHIP.*$}).
            without_content(%r{.*CVMFS_REPOSITORY_TAG.*$}).
            without_content(%r{^CVMFS_HTTP_PROXY.*$}).
            without_content(%r{^CVMFS_QUOTA_LIMIT.*$}).
            without_content(%r{^CVMFS_EXTERNAL_FALLBACK_PROXY=.*$}).
            without_content(%r{^CVMFS_EXTERNAL_HTTP_PROXY=.*$}).
            without_content(%r{^CVMFS_EXTERNAL_TIMEOUT=.*$}).
            without_content(%r{^CVMFS_EXTERNAL_TIMEOUT_DIRECT=.*$}).
            without_content(%r{^CVMFS_EXTERNAL_URL=.*$}).
            with_content("# cvmfs files.example.org.local file installed with puppet.\n# this files overrides and extends the values contained\n# within the files.example.org.conf file.\n\n")
        }

        it { is_expected.not_to contain_mount('/cvmfs/files.example.org') }

        context 'with lots of parameters set' do
          let(:params) do
            {
              cvmfs_use_geoapi: 'yes',
              cvmfs_follow_redirects: 'yes',
              cvmfs_memcache_size: 2000,
              cvmfs_claim_ownership: 'yes',
              cvmfs_repository_tag: 'testing',
              cvmfs_uid_map: { 123 => 12 },
              cvmfs_gid_map: { 137 => 42 },
              cvmfs_quota_limit: 54_321,
              cvmfs_keys_dir: '/etc/cvmfs/keys/example.org',
              cvmfs_external_fallback_proxy: 'http://external-fallback.example.org:3128',
              cvmfs_external_http_proxy: 'http://http-proxy.example.org:2138',
              cvmfs_external_timeout: 100,
              cvmfs_external_timeout_direct: 450,
              cvmfs_external_url: 'http://external-url.example.org:80',
            }
          end

          it {
            is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with_content(%r{^CVMFS_MEMCACHE_SIZE=2000$}).
              with_content(%r{^CVMFS_USE_GEOAPI='yes'$}).
              with_content(%r{^CVMFS_FOLLOW_REDIRECTS='yes'$}).
              with_content(%r{^CVMFS_CLAIM_OWNERSHIP='yes'$}).
              with_content(%r{^CVMFS_REPOSITORY_TAG='testing'$}).
              with_content(%r{^CVMFS_UID_MAP='/etc/cvmfs/config.d/files.example.org.uid_map'$}).
              with_content(%r{^CVMFS_GID_MAP='/etc/cvmfs/config.d/files.example.org.gid_map'$}).
              with_content(%r{^CVMFS_QUOTA_LIMIT='54321'$}).
              with_content(%r{^CVMFS_KEYS_DIR='/etc/cvmfs/keys/example.org'$}).
              with_content(%r{^CVMFS_EXTERNAL_FALLBACK_PROXY='http://external-fallback.example.org:3128'$}).
              with_content(%r{^CVMFS_EXTERNAL_HTTP_PROXY='http://http-proxy.example.org:2138'$}).
              with_content(%r{^CVMFS_EXTERNAL_TIMEOUT='100'$}).
              with_content(%r{^CVMFS_EXTERNAL_TIMEOUT_DIRECT='450'$}).
              with_content(%r{^CVMFS_EXTERNAL_URL='http://external-url.example.org:80'$})
          }

          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.uid_map').with_content(%r{^123 12$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.gid_map').with_content(%r{^137 42$}) }
        end
      end

      context 'with mount_method mount set on main class' do
        let(:pre_condition) do
          'class{"cvmfs": cvmfs_http_proxy => undef,  mount_method => "mount"}'
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_mount('/cvmfs/files.example.org').with(
            options: 'defaults,_netdev,nodev',
            device: 'files.example.org'
          )
        }

        context 'with mount_options set to an array' do
          let(:params) do
            {
              mount_options: %w[one two three],
            }
          end

          it { is_expected.to contain_mount('/cvmfs/files.example.org').with_options('one,two,three') }
        end
      end

      context 'with mount_method mount and a config_repo set on main class' do
        let(:pre_condition) do
          [
            'class{"cvmfs": cvmfs_http_proxy => undef,  mount_method => "mount", config_repo => "cvmfs-config.example.org"}',
            'cvmfs::mount{"cvmfs-config.example.org":}',
          ]
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_mount('/cvmfs/files.example.org').with(
            options: 'defaults,_netdev,nodev,x-systemd.requires-mounts-for=/cvmfs/cvmfs-config.example.org',
            device: 'files.example.org'
          )
        }

        it {
          is_expected.to contain_mount('/cvmfs/cvmfs-config.example.org').with(
            options: 'defaults,_netdev,nodev',
            device: 'cvmfs-config.example.org'
          )
        }
      end
    end
  end
end
