require 'spec_helper'

describe 'cvmfs::domain' do

  let(:title) {'example.org'}
  
  context 'with defaults, cvmfsversion and cvmfspartsize set' do
    let(:facts) {{:concat_basedir => '/tmp',
                   :osfamily => 'RedHat',
                   :uptime_days => 1,
                    :operatingsystemrelease => '7.1.1503',
                    :kernelrelease => '3.10.0-229.1.2.el7.x86_64',
                    :cvmfsversion => '2.1.20', :cvmfspartsize => '20000'}}

    it { should compile.with_all_deps }
    it { should contain_file('/etc/cvmfs/domain.d/example.org.local').with_content("# cvmfs example.org.local file installed with puppet.\n# this files overrides and extends the values contained\n# within the example.org.conf file.\n\n") } 

    context 'with cvmfs_use_geoapi set' do
      let(:params) {{:cvmfs_use_geoapi => 'yes' }}
      it { should contain_file('/etc/cvmfs/domain.d/example.org.local').with({
       'content' => /^CVMFS_USE_GEOAPI='yes'$/})}
    end
    context 'with cvmfs_follow_redirects set to yes' do
      let(:params) {{:cvmfs_follow_redirects => 'yes' }}
      it { should contain_file('/etc/cvmfs/domain.d/example.org.local').with({
         'content' => /^CVMFS_FOLLOW_REDIRECTS='yes'$/})}
    end
  end
end

