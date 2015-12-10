require 'spec_helper'

describe 'cvmfs::zero' do

  let(:title) {'files.example.org'}
  
  context 'with user, group, uid and gid set' do 

    let(:params) {{ :user  => 'steve',
                    :uid   => '123',
                    :group => 'steveg',
                    :gid   => '124' }}

    let(:facts) {{ :concat_basedir => '/tmp',
                   :osfamily => 'RedHat',
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
    it { should contain_file('/etc/cvmfs/repositories.d/files.example.org/server.conf').with_content(/^CVMFS_AUTO_TAG=true$/) }
    it { should contain_file('/etc/cvmfs/repositories.d/files.example.org/server.conf').with_content(/^CVMFS_GARBAGE_COLLECTION=false$/) }
    it { should contain_file('/etc/cvmfs/repositories.d/files.example.org/server.conf').with_content(/^CVMFS_AUTO_GC=false$/) }
    it { should_not contain_file('/etc/cvmfs/repositories.d/files.example.org/server.conf').with_content(/^CVMFS_AUTO_GC_TIMESPAN/) }
    it { should_not contain_file('/etc/cvmfs/repositories.d/files.example.org/server.conf').with_content(/^CVMFS_IGNORE_XDIR_HARDLINKS=/) }
    describe 'with auto_tag false' do
      let(:params) {{ :user => 'steve',
                      :uid  => '123',
                      :group => 'steveg',
                      :gid   => '124',
                      :auto_tag => false}}
      it { should contain_file('/etc/cvmfs/repositories.d/files.example.org/server.conf').with_content(/^CVMFS_AUTO_TAG=false$/) }
    end


    describe 'with garbage_collection true' do
      let(:params) {{ :user => 'steve',
                      :uid  => '123',
                      :group => 'steveg',
                      :gid   => '124',
                      :garbage_collection => true}}
      it { should contain_file('/etc/cvmfs/repositories.d/files.example.org/server.conf').with_content(/^CVMFS_GARBAGE_COLLECTION=true$/) }
    end
    describe 'with auto_gc true' do
      let(:params) {{ :user => 'steve',
                      :uid  => '123',
                      :group => 'steveg',
                      :gid   => '124',
                      :auto_gc => true}}
      it { should contain_file('/etc/cvmfs/repositories.d/files.example.org/server.conf').with_content(/^CVMFS_AUTO_GC=true$/) }
      it { should contain_file('/etc/cvmfs/repositories.d/files.example.org/server.conf').with_content(/^CVMFS_AUTO_GC_TIMESPAN='3 days ago'$/) }
      describe 'with auto_gc_timestan set to 5 days ago' do
        let(:params) {{ :user => 'steve',
                        :uid  => '123',
                        :gid  => '124',
                        :group => 'steveg',
                        :auto_gc => true,
                        :auto_gc_timespan => '5 days ago'}}
         it { should contain_file('/etc/cvmfs/repositories.d/files.example.org/server.conf').with_content(/^CVMFS_AUTO_GC_TIMESPAN='5 days ago'$/) } 
      end
    end

    describe 'with ignore_xdir_hardlinks true' do
      let(:params) {{ :user => 'steve',
                      :uid  => '123',
                      :gid  => '124',
                      :group => 'steveg',
                      :ignore_xdir_hardlinks => true}}
      it { should contain_file('/etc/cvmfs/repositories.d/files.example.org/server.conf').with_content(/^CVMFS_IGNORE_XDIR_HARDLINKS=true$/) }
    end


    it { should contain_user('steve').with(
       {'uid' => '123',
        'gid' => '124'
       })
    }
    it { should contain_group('steveg').with({'gid' => '124'} )}

    it { should contain_file('/cvmfs/files.example.org').with({'owner' => 'steve'})} 

    describe 'with repo_store set' do
      let(:params) {{:repo_store => '/storage',
                     :uid => '123',
                     :gid  => '124',
                     :group => 'steveg',
                     :user => 'steve'
                    }}
      it { should contain_file('/etc/httpd/conf.d/files.example.org.conf').with({
        'content' => /Alias \/cvmfs\/files.example.org \/storage\/files.example.org/}) 
      }
    end
  end
end
