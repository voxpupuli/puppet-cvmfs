# frozen_string_literal: true

# Fact: cvmfspartsize
#
# Purpose: Report the size of the volume that cvmfs_cache_base  resides on.
# A yaml file should have been created by puppet so it may take
# two runs of puppet for this fact to become active.

require 'yaml'
Facter.add(:cvmfspartsize) do
  @df_cmd = Facter::Util::Resolution.which('df')
  confine { @df_cmd }
  setcode do
    if File.exist?('/etc/cvmfs/cvmfsfacts.yaml')
      directory = YAML.safe_load(File.open('/etc/cvmfs/cvmfsfacts.yaml'))['cvmfs_cache_base']
      if File.exist?(directory)
        Facter::Core::Execution.execute(%(#{@df_cmd} -m -P #{directory})).split("\n").last.split(%r{\s+})[1].to_i
      end
    end
  end
end
