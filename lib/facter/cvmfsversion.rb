# Fact: cvmfsversion
#
# Purpose: Report the version of cvmfs
#
Facter.add(:cvmfsversion) do
  confine :kernel => "Linux"
  setcode do
    begin
      Facter::Util::Resolution.exec('/usr/bin/cvmfs2 --version 2>&1').split(' ')[2]
    rescue Exception
      Facter.debug('cvmfs not available')
    end
  end
end

