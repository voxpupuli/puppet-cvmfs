require 'spec_helper'

describe 'cvmfs::domain' do
  let(:pre_condition) do
    'class{cvmfs: cvmfs_http_proxy => undef}'
  end

  let(:title) { 'example.org' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with defaults and cvmfspartsize fact set' do
        let(:facts) do
          facts.merge(cvmfspartsize: '10000000')
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/cvmfs/domain.d/example.org.local').with_content("# cvmfs example.org.local file installed with puppet.\n# this files overrides and extends the values contained\n# within the example.org.conf file.\n\n") }

        context 'with cvmfs_use_geoapi set' do
          let(:params) { { cvmfs_use_geoapi: 'yes' } }

          it do
            is_expected.to contain_file('/etc/cvmfs/domain.d/example.org.local').with('content' => %r{^CVMFS_USE_GEOAPI='yes'$})
          end
        end
        context 'with cvmfs_follow_redirects set to yes' do
          let(:params) { { cvmfs_follow_redirects: 'yes' } }

          it do
            is_expected.to contain_file('/etc/cvmfs/domain.d/example.org.local').with('content' => %r{^CVMFS_FOLLOW_REDIRECTS='yes'$})
          end
        end
        context 'with cvmfs_quota_limit set' do
          let(:params) { { cvmfs_quota_limit: 12_345 } }

          it do
            is_expected.to contain_file('/etc/cvmfs/domain.d/example.org.local').with('content' => %r{^CVMFS_QUOTA_LIMIT='12345'$})
          end
        end
      end
    end
  end
end
