require 'spec_helper'

describe 'cvmfs::mount' do
  let(:pre_condition) do
    'class{"cvmfs": cvmfs_http_proxy => undef}'
  end
  let(:title) { 'files.example.org' }

  context 'with and cvmfspartsize fact set' do
    let(:facts) do
      { concat_basedir: '/tmp',
        osfamily: 'RedHat',
        operatingsystem: 'CentOS',
        operatingsystemmajrelease: '7',
        uptime_days: 1,
        architecture: 'x86_64',
        operatingsystemrelease: '7.1.1503',
        augeasversion: '1.4.0',
        cvmfsversion: '2.1.20',
        kernelrelease: '3.10.0-229.1.2.el7.x86_64',
        cvmfspartsize: '20000' }
    end

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with_content("# cvmfs files.example.org.local file installed with puppet.\n# this files overrides and extends the values contained\n# within the files.example.org.conf file.\n\n") }
    it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without_content(%r{.*CVMFS_MEMCACHE_SIZE.*$}) }
    it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without_content(%r{.*CVMFS_USE_GEOAPI.*$}) }
    it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without_content(%r{.*CVMFS_FOLLOW_REDIRECTS.*$}) }
    it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without_content(%r{.*CVMFS_CLAIM_OWNERSHIP.*$}) }
    it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').without('content' => %r{^CVMFS_HTTP_PROXY.*$}) }
    context 'with lots of  parameters set' do
      let(:params) do
        {
          cvmfs_use_geoapi: 'yes',
          cvmfs_follow_redirects: 'yes',
          cvmfs_memcache_size: 2000,
          cvmfs_claim_ownership: 'yes'
        }
      end

      it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_MEMCACHE_SIZE=2000$}) }
      it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_USE_GEOAPI='yes'$}) }
      it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_FOLLOW_REDIRECTS='yes'$}) }
      it { is_expected.to contain_file('/etc/cvmfs/config.d/files.example.org.local').with('content' => %r{^CVMFS_CLAIM_OWNERSHIP='yes'$}) }
    end
  end
end
