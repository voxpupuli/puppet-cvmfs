require 'spec_helper'
describe 'cvmfs' do

  context 'with defaults for all parameters' do
    let(:facts) {{ :concat_basedir => '/tmp',
                   :osfamily => 'RedHat', 
                   :uptime_days => 1,
                   :operatingsystem => 'CentOS',
                   :operatingsystemrelease => '7.1.1503',
                   :operatingsystemmajrelease => '7',
                   :architecture => 'x86_64',
                   :kernelrelease => '3.10.0-229.1.2.el7.x86_64' }}

    it { should contain_class('cvmfs::install') }
    it { should_not contain_class('cvmfs::config') }
    it { should_not contain_class('cvmfs::service') }
    it { should contain_package('cvmfs').with_ensure('present')}

    context 'with cvmfsversion and cvmfspartsize facts set' do
      let(:facts) {{:concat_basedir => '/tmp',
                    :osfamily => 'RedHat',
                    :uptime_days => 1,
                    :operatingsystemrelease => '7.1.1503',
                    :operatingsystemmajrelease => '7',
                    :kernelrelease => '3.10.0-229.1.2.el7.x86_64',
                    :architecture => 'x86_64',
                    :cvmfsversion => '2.1.20', :cvmfspartsize => '20000'}}
      it { should contain_class('cvmfs::config') }
      it { should contain_class('cvmfs::service') }
      it { should contain_service('autofs') }

      # cvmfs-config repository should be disable by default.
      #
      it { should contain_yumrepo('cvmfs').with(
           'enabled' => '1',
           'baseurl' => 'http://cern.ch/cvmrepo/yum/cvmfs/EL/7/x86_64' ,
           'gpgcheck' => '1',
           'gpgkey'   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM')
      }
      it { should contain_yumrepo('cvmfs-testing').with(
           'enabled' => '0',
           'baseurl' => 'http://cern.ch/cvmrepo/yum/cvmfs-testing/EL/7/x86_64' ,
           'gpgcheck' => '1',
           'gpgkey'   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM')
      }
      it { should contain_yumrepo('cvmfs-config').with(
           'enabled' => '0',
           'baseurl' => 'http://cern.ch/cvmrepo/yum/cvmfs-config/EL/7/x86_64' ,
           'gpgcheck' => '1',
           'gpgkey'   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM')
      }

      context 'with cvmfs_yum_config_enabled set to 1' do
        let(:params) {{:cvmfs_yum_config_enabled => '1'}}
        it { should contain_yumrepo('cvmfs-config').with_enabled('1') }
      end

      context 'with cvmfs_yum_config set to http://example.org/yum' do
        let(:params) {{:cvmfs_yum_config => 'http://example.org/yum'}}
        it { should contain_yumrepo('cvmfs-config').with_baseurl('http://example.org/yum') }
      end

      context 'with cvmfs_yum_gpgcheck set to 0' do
        let(:params) {{:cvmfs_yum_gpgcheck => '0'}}
        it { should contain_yumrepo('cvmfs').with_gpgcheck('0') }
        it { should contain_yumrepo('cvmfs-testing').with_gpgcheck('0') }
        it { should contain_yumrepo('cvmfs-config').with_gpgcheck('0') }
      end

      context 'with cvmfs_yum_gpgkey set to http://example.org/key.gpg' do
        let(:params) {{:cvmfs_yum_gpgkey => 'http://example.org/key.gpg'}}
        it { should contain_yumrepo('cvmfs').with_gpgkey('http://example.org/key.gpg') }
        it { should contain_yumrepo('cvmfs-testing').with_gpgkey('http://example.org/key.gpg') }
        it { should contain_yumrepo('cvmfs-config').with_gpgkey('http://example.org/key.gpg') }
      end

      context 'with cvmfs_yum_manage_repo set to true' do
        let(:params) {{:cvmfs_yum_manage_repo => true}}
        it { should contain_class('cvmfs::yum') }
        it { should contain_yumrepo('cvmfs') }
        it { should contain_yumrepo('cvmfs-testing') }
        it { should contain_yumrepo('cvmfs-config') }
      end

      context 'with cvmfs_yum_manage_repo set to false' do
        let(:params) {{:cvmfs_yum_manage_repo => false}}
        it { should_not contain_class('cvmfs::yum') }
        it { should_not contain_yumrepo('cvmfs') }
        it { should_not contain_yumrepo('cvmfs-testing') }
        it { should_not contain_yumrepo('cvmfs-config') }
      end

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
      context 'with cvmfs_server_url set to something, to be deprecated' do
        let(:params) {{:cvmfs_server_url => 'http://example.org/cvmfs/files.repo.org'}}
        it { should compile.with_all_deps }
      end
      context 'with cvmfs_mount_rw not set' do
        it { should contain_concat__fragment('cvmfs_default_local_header').
             without_content(/^CVMFS_MOUNT_RW/)
        }
      end
      context 'with cvmfs_mount_rw set to true' do
        let(:params) {{:cvmfs_mount_rw => 'yes'}}
        it { should contain_concat__fragment('cvmfs_default_local_header').
             with_content(/^CVMFS_MOUNT_RW=yes$/)
        }
      end
    end
  end
end
