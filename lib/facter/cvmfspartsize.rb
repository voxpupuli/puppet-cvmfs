# Fact: cvmfspartsize
#
# Purpose: Report the size of the volume that cvmfs_cache_base  resides on.
# A yaml file should have been created by puppet so it may take
# two runs of puppet for this fact to become active.

require 'yaml'
Facter.add(:cvmfspartsize) do
  confine kernel: 'Linux'
  setcode do
    if File.exist?('/etc/cvmfs/cvmfsfacts.yaml')
      directory = YAML.load(File.open('/etc/cvmfs/cvmfsfacts.yaml'))['cvmfs_cache_base']
      Facter::Util::Resolution.exec("/bin/df -m -P #{directory}").split("\n").last.split(%r{\s+})[1]
    end
  end
end
