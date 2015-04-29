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
      it { should contain_service('autofs') }


      context 'with manage_autofs_service true' do
        let(:params) {{:manage_autofs_service => true}}
        it { should contain_service('autofs') }
      end
      context 'with manage_autofs_service false' do
        let(:params) {{:manage_autofs_service => false}}
        it { should_not contain_service('autofs') }
      end

      it { should contain_augeas('cvmfs_automaster') }
      context 'with config_automaster true' do
        let(:params) {{:config_automaster  => true}}
        it { should contain_augeas('cvmfs_automaster') }
      end
      context 'with config_automaster false' do
        let(:params) {{:config_automaster  => false}}
        it { should_not contain_augeas('cvmfs_automaster') }
      end

    end

  end

end
