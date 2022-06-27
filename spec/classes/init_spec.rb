# frozen_string_literal: true

require 'spec_helper'
describe 'cvmfs' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with cmvfs_proxy_unset for all parameters' do
        let(:params) do
          { cvmfs_http_proxy: :undef }
        end

        it { is_expected.to contain_class('cvmfs::install') }
        it { is_expected.to contain_class('cvmfs::config') }
        it { is_expected.to contain_class('cvmfs::service') }
        it { is_expected.to contain_package('cvmfs').with_ensure('present') }

        it { is_expected.to contain_concat__fragment('cvmfs_default_local_header') }
        it { is_expected.to contain_concat__fragment('cvmfs_default_local_header').without_content(%r{^CVMFS_INSTRUMENT_FUSE.*$}) }
        it { is_expected.to contain_concat__fragment('cvmfs_default_local_repo_start') }
        it { is_expected.to contain_concat__fragment('cvmfs_default_local_repo_start').with_content('CVMFS_REPOSITORIES=\'') }
        it { is_expected.to contain_concat__fragment('cvmfs_default_local_repo_end') }
        it { is_expected.to contain_concat__fragment('cvmfs_default_local_repo_end').with_content("'\n\n") }
        it { is_expected.not_to contain_concat__fragment('cvmfs_default_local_repo') }
        it { is_expected.not_to contain_file('/etc/cvmfs/config.d/default.uid_map') }
        it { is_expected.not_to contain_file('/etc/cvmfs/config.d/default.gid_map') }
        it { is_expected.to contain_concat__fragment('cvmfs_default_local_header').without_content(%r{^CVMFS_UID_MAP.*$}) }
        it { is_expected.to contain_concat__fragment('cvmfs_default_local_header').without_content(%r{^CVMFS_GID_MAP.*$}) }

        case facts[:os]['family']
        when 'Debian'
          it { is_expected.to contain_class('cvmfs::apt') }
          it { is_expected.not_to contain_class('cvmfs::yum') }
          it { is_expected.to contain_package('cvmfs').that_requires('Class[cvmfs::apt]') }
        else
          it { is_expected.not_to contain_class('cvmfs::apt') }
          it { is_expected.to contain_class('cvmfs::yum') }
          it { is_expected.to contain_package('cvmfs').that_requires('Class[cvmfs::yum]') }
        end

        context 'with cvmfs_http_proxy set' do
          let(:params) do
            super().merge(cvmfs_http_proxy: 'http://foobar.example.org:3128')
          end

          it { is_expected.to contain_concat__fragment('cvmfs_default_local_header').with_content(%r{^CVMFS_HTTP_PROXY='http://foobar.example.org:3128'$}) }
        end

        context 'with defaults and cvmfspartsize fact unset' do
          it { is_expected.to contain_class('cvmfs::config') }
          it { is_expected.to contain_concat__fragment('cvmfs_default_local_header').with_content(%r{^CVMFS_QUOTA_LIMIT='1000'$}) }

          context 'with cvmfs_quota_ratio set' do
            let(:params) do
              { cvmfs_quota_limit: 'auto',
                cvmfs_http_proxy: :undef,
                cvmfs_quota_ratio: 0.75 }
            end

            it { is_expected.to contain_concat__fragment('cvmfs_default_local_header').with_content(%r{^CVMFS_QUOTA_LIMIT='7500'$}) }
          end
        end

        context 'with defaults and cvmfspartsize fact set' do
          let(:facts) do
            facts.merge(cvmfspartsize: '10000000')
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_service('autofs') }

          # cvmfs-config repository should be disable by default.
          #
          case facts[:os]['family']
          when 'RedHat'
            case facts[:os]['release']['major']
            when '7'
              it { is_expected.to contain_yumrepo('cvmfs').with_baseurl('https://cern.ch/cvmrepo/yum/cvmfs/EL/7/x86_64') }
              it { is_expected.to contain_yumrepo('cvmfs-testing').with_baseurl('https://cern.ch/cvmrepo/yum/cvmfs-testing/EL/7/x86_64') }
              it { is_expected.to contain_yumrepo('cvmfs-config').with_baseurl('https://cern.ch/cvmrepo/yum/cvmfs-config/EL/7/x86_64') }
            else
              it { is_expected.to contain_yumrepo('cvmfs').with_baseurl('https://cern.ch/cvmrepo/yum/cvmfs/EL/8/x86_64') }
              it { is_expected.to contain_yumrepo('cvmfs-testing').with_baseurl('https://cern.ch/cvmrepo/yum/cvmfs-testing/EL/8/x86_64') }
              it { is_expected.to contain_yumrepo('cvmfs-config').with_baseurl('https://cern.ch/cvmrepo/yum/cvmfs-config/EL/8/x86_64') }
            end
            it do
              is_expected.to contain_yumrepo('cvmfs').with(
                'enabled' => true,
                'gpgcheck' => true,
                'gpgkey' => 'https://cvmrepo.web.cern.ch/yum/RPM-GPG-KEY-CernVM',
                'priority' => 80
              )
            end

            it do
              is_expected.to contain_yumrepo('cvmfs-testing').with(
                'enabled' => false,
                'gpgcheck' => true,
                'gpgkey' => 'https://cvmrepo.web.cern.ch/yum/RPM-GPG-KEY-CernVM'
              )
            end

            it do
              is_expected.to contain_yumrepo('cvmfs-config').with(
                'enabled' => false,
                'gpgcheck' => true,
                'gpgkey' => 'https://cvmrepo.web.cern.ch/yum/RPM-GPG-KEY-CernVM'
              )
            end
          else
            case facts[:os]['distro']['codename']
            when 'focal'
              it {
                is_expected.to contain_apt__source('cvmfs').with({
                                                                   'ensure' => 'present',
                                                                   'location' => 'https://cvmrepo.web.cern.ch/cvmrepo/apt',
                                                                   'release' => 'focal-prod',
                                                                   'allow_unsigned' => false,
                                                                 })
              }

              it {
                is_expected.to contain_apt__source('cvmfs-testing').with({
                                                                           'ensure' => 'absent',
                                                                           'location' => 'https://cvmrepo.web.cern.ch/cvmrepo/apt',
                                                                           'release' => 'focal-testing',
                                                                           'allow_unsigned' => false,
                                                                         })
              }
            end
          end

          context 'with mount method setto autofs' do
            let(:params) do
              { mount_method: 'autofs',
                cvmfs_http_proxy: :undef }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_service('autofs') }

            case [facts[:os]['family'], facts[:os]['release']['major']]
            when %w[RedHat 7], ['Debian', '18.04']
              it { is_expected.to contain_augeas('cvmfs_automaster') }
              it { is_expected.not_to contain_file('/etc/auto.master.d/cvmfs.autofs') }
            else
              it { is_expected.to contain_file('/etc/auto.master.d/cvmfs.autofs') }
              it { is_expected.not_to contain_augeas('cvmfs_automaster') }
            end
          end

          context 'with mount method setto mount' do
            let(:params) do
              { mount_method: 'mount',
                cvmfs_http_proxy: :undef }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.not_to contain_service('autofs') }
            it { is_expected.not_to contain_file('/etc/auto.master.d/cvmfs.autofs') }
            it { is_expected.not_to contain_augeas('cvmfs_automaster') }
          end

          context 'with cvmfs_yum_config_enabled set to 1' do
            let(:params) do
              { cvmfs_yum_config_enabled: 1,
                cvmfs_http_proxy: :undef }
            end

            it { is_expected.to compile.and_raise_error(%r{'cvmfs_yum_config_enabled' is deprecated}) }
          end

          context 'with repo_config_enabled set to 1' do
            let(:params) do
              { repo_config_enabled: true,
                cvmfs_http_proxy: :undef }
            end

            case facts[:os]['family']
            when 'RedHat'
              it { is_expected.to contain_yumrepo('cvmfs-config').with_enabled(true) }
            else
              it { is_expected.not_to contain_yumrepo('cvmfs-config') }
            end
          end

          context 'with repo_base set to http://example.org/base' do
            let(:params) do
              { repo_base: 'http://example.org/base',
                cvmfs_http_proxy: :undef }
            end

            case facts[:os]['family']
            when 'RedHat'
              it { is_expected.to contain_yumrepo('cvmfs').with_baseurl(%r{^http://example.org/base/cvmfs/EL/\d+/x86_64$}) }
              it { is_expected.to contain_yumrepo('cvmfs-testing').with_baseurl(%r{^http://example.org/base/cvmfs-testing/EL/\d+/x86_64$}) }
              it { is_expected.to contain_yumrepo('cvmfs-config').with_baseurl(%r{^http://example.org/base/cvmfs-config/EL/\d+/x86_64$}) }
            else
              it { is_expected.to contain_apt__source('cvmfs').with_location('http://example.org/base') }
              it { is_expected.to contain_apt__source('cvmfs-testing').with_location('http://example.org/base') }
            end
          end

          context 'with cvmfs_quota_ratio set' do
            let(:params) do
              { cvmfs_quota_limit: 'auto',
                cvmfs_http_proxy: :undef,
                cvmfs_quota_ratio: 0.5 }
            end

            it { is_expected.to contain_concat__fragment('cvmfs_default_local_header').with_content(%r{^CVMFS_QUOTA_LIMIT='5000000'$}) }
          end

          context 'with repo_gpgcheck set to 0 and repo_priority 100' do
            let(:params) do
              { repo_gpgcheck: false,
                repo_priority: 100,
                cvmfs_http_proxy: :undef }
            end

            case facts[:os]['family']
            when 'RedHat'
              it { is_expected.to contain_yumrepo('cvmfs').with_gpgcheck(false) }
              it { is_expected.to contain_yumrepo('cvmfs').with_priority(100) }
              it { is_expected.to contain_yumrepo('cvmfs-testing').with_gpgcheck(false) }
              it { is_expected.to contain_yumrepo('cvmfs-testing').with_priority(100) }
              it { is_expected.to contain_yumrepo('cvmfs-config').with_gpgcheck(false) }
              it { is_expected.to contain_yumrepo('cvmfs-config').with_priority(100) }
            else
              it { is_expected.to contain_apt__source('cvmfs').with_allow_unsigned(true) }
              it { is_expected.to contain_apt__source('cvmfs-testing').with_allow_unsigned(true) }
            end
          end

          context 'with repo_gpgkey set to http://example.org/key.gpg' do
            let(:params) do
              { repo_gpgkey: 'http://example.org/key.gpg',
                cvmfs_http_proxy: :undef }
            end

            case facts[:os]['family']
            when 'RedHat'
              it { is_expected.to contain_yumrepo('cvmfs').with_gpgkey('http://example.org/key.gpg') }
              it { is_expected.to contain_yumrepo('cvmfs-testing').with_gpgkey('http://example.org/key.gpg') }
              it { is_expected.to contain_yumrepo('cvmfs-config').with_gpgkey('http://example.org/key.gpg') }
            else
              it {
                is_expected.to contain_apt__source('cvmfs').with_key(
                  { 'ensure' => 'refreshed', 'id' => '70B9890488208E315ED45208230D389D8AE45CE7', 'source' => 'http://example.org/key.gpg' }
                )
              }
            end
          end

          context 'with repo_manage set to true' do
            let(:params) do
              { repo_manage: true,
                cvmfs_http_proxy: :undef }
            end

            case facts[:os]['family']
            when 'RedHat'
              it { is_expected.to contain_class('cvmfs::yum') }
              it { is_expected.not_to contain_class('cvmfs::apt') }
            else
              it { is_expected.to contain_class('cvmfs::apt') }
              it { is_expected.not_to contain_class('cvmfs::yum') }
            end
          end

          context 'with repo_manage set to false' do
            let(:params) do
              { repo_manage: false,
                cvmfs_http_proxy: :undef }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to have_yumrepo_resource_count(0) }
            it { is_expected.not_to contain_class('cvmfs::yum') }
            it { is_expected.not_to contain_class('cvmfs::apt') }
          end

          context 'with manage_autofs_service true' do
            let(:params) do
              { manage_autofs_service: true,
                cvmfs_http_proxy: :undef }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_service('autofs') }
          end

          context 'with manage_autofs_service false' do
            let(:params) do
              { manage_autofs_service: false,
                cvmfs_http_proxy: :undef }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.not_to contain_service('autofs') }
          end

          context 'with cvmfs_include_fsck not set' do
            it do
              is_expected.not_to contain_class('cvmfs::fsck')
            end
          end

          context 'with cvmfs_fsck set to true' do
            let(:params) do
              { cvmfs_fsck: true,
                cvmfs_http_proxy: :undef }
            end

            it do
              is_expected.to contain_class('cvmfs::fsck')
            end
          end

          context 'with cvmfs_dns_min_ttl not set' do
            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                without_content(%r{^CVMFS_DNS_MIN_TTL})
            end
          end

          context 'with cvmfs_dns_min_ttl set to 20' do
            let(:params) do
              { cvmfs_dns_min_ttl: 20,
                cvmfs_http_proxy: :undef }
            end

            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                with_content(%r{^CVMFS_DNS_MIN_TTL='20'$})
            end
          end

          context 'with cvmfs_dns_max_ttl not set' do
            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                without_content(%r{^CVMFS_DNS_MAX_TTL})
            end
          end

          context 'with cvmfs_dns_max_ttl set to 200' do
            let(:params) do
              { cvmfs_dns_max_ttl: 200,
                cvmfs_http_proxy: :undef }
            end

            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                with_content(%r{^CVMFS_DNS_MAX_TTL='200'$})
            end
          end

          context 'with cvmfs_ipfamily_prefer not set' do
            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                without_content(%r{^CVMFS_IPFAMILY_PREFER})
            end
          end

          context 'with cvmfs_ipfamily_prefer set to 6' do
            let(:params) do
              { cvmfs_ipfamily_prefer: 6,
                cvmfs_http_proxy: :undef }
            end

            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                with_content(%r{^CVMFS_IPFAMILY_PREFER=6$})
            end
          end

          context 'with cvmfs_ipfamily_prefer set to 5' do
            let(:params) do
              { cvmfs_ipfamily_prefer: 5,
                cvmfs_http_proxy: :undef }
            end

            it { is_expected.not_to compile }
          end

          context 'with cvmfs_instrument_fuse set true' do
            let(:params) do
              { cvmfs_instrument_fuse: true,
                cvmfs_http_proxy: :undef }
            end

            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                with_content(%r{^CVMFS_INSTRUMENT_FUSE=true$})
            end
          end

          context 'with cvmfs_instrument_fuse set false' do
            let(:params) do
              { cvmfs_instrument_fuse: false,
                cvmfs_http_proxy: :undef }
            end

            it do
              is_expected.not_to contain_concat__fragment('cvmfs_default_local_header').
                with_content(%r{^CVMFS_INSTRUMENT_FUSE.*$})
            end
          end

          context 'with cvmfs_mount_rw not set' do
            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                without_content(%r{^CVMFS_MOUNT_RW})
            end
          end

          context 'with cvmfs_mount_rw set to true' do
            let(:params) do
              { cvmfs_mount_rw: 'yes',
                cvmfs_http_proxy: :undef }
            end

            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                with_content(%r{^CVMFS_MOUNT_RW=yes$})
            end
          end

          context 'with cvmfs_memcache_size not set' do
            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                without_content(%r{^CVMFS_MEMCACHE_SIZE})
            end
          end

          context 'with cvmfs_memcache set to a value' do
            let(:params) do
              { cvmfs_memcache_size: 2000,
                cvmfs_http_proxy: :undef }
            end

            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                with_content(%r{^CVMFS_MEMCACHE_SIZE=2000$})
            end
          end

          context 'with cvmfs_claim_ownership not set' do
            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                without_content(%r{^CVMFS_CLAIM_OWNERSHIP})
            end
          end

          context 'with cvmfs_claim_ownership set to a value' do
            let(:params) do
              { cvmfs_claim_ownership: 'yes',
                cvmfs_http_proxy: :undef }
            end

            it do
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                with_content(%r{^CVMFS_CLAIM_OWNERSHIP='yes'$})
            end
          end

          context 'with cvmfs_uid_map set to a value' do
            let(:params) do
              { cvmfs_uid_map: { 123 => 12 },
                cvmfs_http_proxy: :undef }
            end

            it do
              is_expected.to contain_file('/etc/cvmfs/config.d/default.uid_map').with('content' => %r{^123 12$})
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                with_content(%r{^CVMFS_UID_MAP='/etc/cvmfs/config.d/default.uid_map'$})
            end
          end

          context 'with cvmfs_gid_map set to a value' do
            let(:params) do
              { cvmfs_gid_map: { 137 => 42 },
                cvmfs_http_proxy: :undef }
            end

            it do
              is_expected.to contain_file('/etc/cvmfs/config.d/default.gid_map').with('content' => %r{^137 42$})
              is_expected.to contain_concat__fragment('cvmfs_default_local_header').
                with_content(%r{^CVMFS_GID_MAP='/etc/cvmfs/config.d/default.gid_map'$})
            end
          end

          context 'with cvmfs_domain_hash set' do
            let(:params) do
              super().merge(cvmfs_domain_hash: {
                              'example.org' => { 'cvmfs_server_url' => 'http://foobar.example.org' },
                              'foobar.org' => { 'cvmfs_server_url' => 'http://barfoo.example.net' },
                            })
            end

            it { is_expected.to  contain_cvmfs__domain('example.org').with_cvmfs_server_url('http://foobar.example.org') }
            it { is_expected.to  contain_cvmfs__domain('foobar.org').with_cvmfs_server_url('http://barfoo.example.net') }
          end

          context 'with cvmfs::hash set' do
            let(:params) do
              { cvmfs_hash: { 'one.example.org' => { 'cvmfs_server_url' => 'http://one.example.org/' },
                              'two.example.org' => { 'cvmfs_env_variables' => { 'LOCAL_SITE' => 'jump' } } },
                cvmfs_http_proxy: :undef }
            end

            it { is_expected.to contain_file('/etc/cvmfs/config.d/one.example.org.local').with_content(%r{^CVMFS_SERVER_URL='http://one.example.org/'$}) }
            it { is_expected.to contain_file('/etc/cvmfs/config.d/two.example.org.local').with_content(%r{^export LOCAL_SITE=jump}) }
            it { is_expected.to contain_concat_fragment('cvmfs_default_local_one.example.org').with_content('one.example.org,') }
            it { is_expected.to contain_concat_fragment('cvmfs_default_local_two.example.org').with_content('two.example.org,') }

            context 'with cvmfs_reposiories set' do
              let(:params) do
                super().merge(cvmfs_repositories: 'foo,bar,whatever')
              end

              it { is_expected.not_to contain_concat_fragment('cvmfs_default_local_one.example.org') }
              it { is_expected.not_to contain_concat_fragment('cvmfs_default_local_two.example.org') }
              it { is_expected.not_to contain_concat__fragment('cvmfs_default_local_repo_start') }
              it { is_expected.not_to contain_concat__fragment('cvmfs_default_local_repo_end') }
              it { is_expected.to contain_concat__fragment('cvmfs_default_local_repo').with_content(%r{^CVMFS_REPOSITORIES='foo,bar,whatever'$}) }
            end
          end
        end
      end
    end
  end
end
