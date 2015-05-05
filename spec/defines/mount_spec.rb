require 'spec_helper'

describe 'cvmfs::mount' do

  let(:title) {'files.example.org'}
  
  context 'with defaults, cvmfspartsize, cvmfsversion facts set' do
    let(:facts) {{:osfamily => 'RedHat',
                  :uptime_days => 1,
                  :operatingsystemrelease => '7.1.1503',
                  :kernelrelease => '3.10.0-229.1.2.el7.x86_64',
                  :cvmfsversion => '2.1.20', :cvmfspartsize => '20000'}}
    it { should compile.with_all_deps }

    it { should contain_file('/etc/cvmfs/config.d/files.example.org.local') }
      context 'with cvmfs_use_geoapi set' do
        let(:params) {{:cvmfs_use_geoapi => 'yes' }}
        it { should contain_file('/etc/cvmfs/config.d/files.example.org.local').with({
          'content' => /^CVMFS_USE_GEOAPI='yes'$/})}
        end
    end
end
