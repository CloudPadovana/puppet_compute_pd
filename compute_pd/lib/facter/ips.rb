Facter.add(:ip_manag) do
  setcode do
        Facter::Util::Resolution.exec("/sbin/ifconfig | /bin/awk -F ' *|:' '/inet addr/{print $4}' |/bin/fgrep '192.168.60' ")
  end
end

Facter.add(:ip_data) do
  setcode do
        Facter::Util::Resolution.exec("/sbin/ifconfig | /bin/awk -F ' *|:' '/inet addr/{print $4}' |/bin/fgrep '192.168.61' ")
  end
end


