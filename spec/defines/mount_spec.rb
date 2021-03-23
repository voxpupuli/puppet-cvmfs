require 'spec_helper'

describe 'cvmfs::mount' do
  let(:pre_condition) do
    'class{"cvmfs": cvmfs_http_proxy => undef}'
  end
  let(:title) { 'files.example.org' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with and cvmfspartsize fact set' do
        let(:facts) do
          facts.merge(cvmfspartsize: '10000000')
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local') }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with_content("# cvmfs files.example.org.local file installed with puppet.\n# this files overrides and extends the values contained\n# within the files.example.org.conf file.\n\n") }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without_content(%r{.*CVMFS_MEMCACHE_SIZE.*$}) }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without_content(%r{.*CVMFS_USE_GEOAPI.*$}) }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without_content(%r{.*CVMFS_FOLLOW_REDIRECTS.*$}) }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without_content(%r{.*CVMFS_CLAIM_OWNERSHIP.*$}) }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without_content(%r{.*CVMFS_REPOSITORY_TAG.*$}) }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without('content' => %r{^CVMFS_HTTP_PROXY.*$}) }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without('content' => %r{^CVMFS_QUOTA_LIMIT.*$}) }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without('content' => %r{^CVMFS_EXTERNAL_FALLBACK_PROXY=.*$}) }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without('content' => %r{^CVMFS_EXTERNAL_HTTP_PROXY=.*$}) }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without('content' => %r{^CVMFS_EXTERNAL_TIMEOUT=.*$}) }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without('content' => %r{^CVMFS_EXTERNAL_TIMEOUT_DIRECT=.*$}) }
        it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without('content' => %r{^CVMFS_EXTERNAL_URL=.*$}) }

        context 'with lots of  parameters set' do
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
              cvmfs_external_fallback_proxy: 'http://external-fallback.example.org:3128',
              cvmfs_external_http_proxy: 'http://http-proxy.example.org:2138',
              cvmfs_external_timeout: 100,
              cvmfs_external_timeout_direct: 450,
              cvmfs_external_url: 'http://external-url.example.org:80',
            }
          end

          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_MEMCACHE_SIZE=2000$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_USE_GEOAPI='yes'$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_FOLLOW_REDIRECTS='yes'$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_CLAIM_OWNERSHIP='yes'$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_REPOSITORY_TAG='testing'$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_UID_MAP='/etc/cvmfs/config.d/files.example.org.uid_map'$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_GID_MAP='/etc/cvmfs/config.d/files.example.org.gid_map'$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_QUOTA_LIMIT='54321'$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_EXTERNAL_FALLBACK_PROXY='http://external-fallback.example.org:3128'$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_EXTERNAL_HTTP_PROXY='http://http-proxy.example.org:2138'$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_EXTERNAL_TIMEOUT='100'$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_EXTERNAL_TIMEOUT_DIRECT='450'$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_EXTERNAL_URL='http://external-url.example.org:80'$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.uid_map').with('content' => %r{^123 12$}) }
          it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.gid_map').with('content' => %r{^137 42$}) }
        end
      end
    end
  end
end
