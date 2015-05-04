source ENV['GEM_SOURCE'] || "https://rubygems.org"

# https://github.com/rspec/rspec-core/issues/1864
gem 'rspec', '~> 3.1.0'
gem 'puppetlabs_spec_helper', '>= 0.1.0'
gem 'puppet-lint', '>= 0.3.2'

if RUBY_VERSION != '1.8.7'
  gem 'beaker-rspec',  :require => false
  gem 'pry', :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
