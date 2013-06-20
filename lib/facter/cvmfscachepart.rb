# Fact: cvmfscachepart
#
# Purpose: Report the size of the volume that cvmfs shared cache resides on.
# A yaml file should have been created with obvious configuration below which
# you can guess.
require 'yaml'
Facter.add(:cvmfscachepart) do
  setcode do
    begin
      directory = YAML::load(File.open('/etc/cvmfs/cvmfscachebase.yaml'))['cvmfs_cache_base']
      Facter::Util::Resolution.exec("/bin/df -m -P #{directory}").split("\n").last.split(/\s+/)[1]
    rescue Exception
      Facter.debug('cvmfs not available')
    end
  end
end

