require 'spec_helper'

describe 'cvmfs::domain' do
  let(:pre_condition) do
    'include cvmfs'
  end

  let(:title) { 'example.org' }

  context 'with defaults and cvmfspartsize fact set' do
    let(:facts) do
      { concat_basedir: '/tmp',
        osfamily: 'RedHat',
        uptime_days: 1,
        operatingsystem: 'CentOS',
        operatingsystemmajrelease: '7',
        architecture: 'x86_64',
        operatingsystemrelease: '7.1.1503',
        cvmfsversion: '2.1.20',
        augeasversion: '1.4.0',
        kernelrelease: '3.10.0-229.1.2.el7.x86_64',
        cvmfspartsize: '20000' }
    end

    it { should compile.with_all_deps }
    it { should contain_file('/etc/cvmfs/domain.d/example.org.local').with_content("# cvmfs example.org.local file installed with puppet.\n# this files overrides and extends the values contained\n# within the example.org.conf file.\n\n") }

    context 'with cvmfs_use_geoapi set' do
      let(:params) { { cvmfs_use_geoapi: 'yes' } }
      it do
        should contain_file('/etc/cvmfs/domain.d/example.org.local').with('content' => %r{^CVMFS_USE_GEOAPI='yes'$})
      end
    end
    context 'with cvmfs_follow_redirects set to yes' do
      let(:params) { { cvmfs_follow_redirects: 'yes' } }
      it do
        should contain_file('/etc/cvmfs/domain.d/example.org.local').with('content' => %r{^CVMFS_FOLLOW_REDIRECTS='yes'$})
      end
    end
  end
end
