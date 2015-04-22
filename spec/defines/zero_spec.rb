require 'spec_helper'

describe 'cvmfs::zero' do

  let(:title) {'files.example.org'}
  
  context 'with user and uid set' do 

    let(:params) {{ :user => 'steve',
                    :uid  => '123'}}

    let(:facts) {{ :osfamily => 'RedHat',
                   :uptime_days => 1,
                   :operatingsystemrelease => '7.1.1503',
                   :kernelrelease => '3.10.0-229.1.2.el7.x86_64' }}

    it { should compile.with_all_deps}

    it { should contain_class('cvmfs::zero::install') }
    it { should contain_class('cvmfs::zero::config') }
    it { should contain_class('cvmfs::zero::service') }
    it { should contain_class('cvmfs::zero::yum') }

    it { should contain_yumrepo('cvmfs') }
    it { should contain_yumrepo('cvmfs-testing') }
    it { should contain_yumrepo('cvmfs-kernel') }
    it { should contain_package('kernel') }
    it { should contain_package('cvmfs-server') }
    it { should contain_package('cvmfs') }
    it { should contain_package('httpd') }
    it { should contain_service('httpd') }
    it { should contain_file('/etc/httpd/conf.d/files.example.org.conf').with({
        'content' => /Alias \/cvmfs\/files.example.org \/srv\/cvmfs\/files.example.org/}) 
    }

    it { should contain_file('/etc/cvmfs/repositories.d/files.example.org/client.conf').with({
        'content' => /CVMFS_CACHE_BASE=\/var\/spool\/cvmfs\/files.example.org\/cache/})
    }
    it { should contain_file('/etc/cvmfs/repositories.d/files.example.org/server.conf') }
    it { should contain_user('steve').with(
       {'uid' => '123',
        'gid' => '123'
       })
    }
    it { should contain_group('steve').with({'gid' => '123'} )}

    it { should contain_file('/cvmfs/files.example.org').with({'owner' => 'steve'})} 

    describe 'with repo_store set' do
      let(:params) {{:repo_store => '/storage',
                     :uid => '123',
                     :user => 'steve'
                    }}
      it { should contain_file('/etc/httpd/conf.d/files.example.org.conf').with({
        'content' => /Alias \/cvmfs\/files.example.org \/storage\/files.example.org/}) 
      }
    end
  end
end
