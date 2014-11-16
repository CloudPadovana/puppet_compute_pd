Facter.add(:ifs_array) do
  setcode do
   interfaces = Facter.value(:interfaces)
   # the 'interfaces' fact returns a single comma-delimited string, e.g., "lo0,eth0,eth1"
   ifs_array = interfaces.split(',')
   ifs_array
  end
end
