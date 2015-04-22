require 'spec_helper'
describe 'cvmfs' do

  context 'with defaults for all parameters' do
    let(:facts) {{ :osfamily => 'RedHat', :uptime_days => 1,
                   :operatingsystemrelease => '7.1.1503',
                   :kernelrelease => '3.10.0-229.1.2.el7.x86_64' }}

    it { should contain_class('cvmfs::install') }
    it { should_not contain_class('cvmfs::config') }
    it { should_not contain_class('cvmfs::service') }
    it { should contain_package('cvmfs').with_ensure('present')}

    context 'with cvmfsversion and cvmfspartsize facts set' do
      let(:facts) {{:osfamily => 'RedHat',
                    :uptime_days => 1,
                    :operatingsystemrelease => '7.1.1503',
                    :kernelrelease => '3.10.0-229.1.2.el7.x86_64',
                    :cvmfsversion => '2.1.20', :cvmfspartsize => '20000'}}
      it { should contain_class('cvmfs::config') }
      it { should contain_class('cvmfs::service') }
    end

  end

end
