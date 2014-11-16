class compute_pd::firewall {

  exec { "open-port-5900":
    command	=> "iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 5900:5999 -j ACCEPT",
    unless	=> "iptables-save | grep 5900 | grep INPUT | grep ACCEPT | grep NEW | wc -l | xargs test 1 -eq",
    notify => Exec["ip-tables-save"]
  }

  exec { "open-port-16509":
    command     => "iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 16509 -j ACCEPT",
    unless      => "iptables-save | grep 16509 | grep INPUT | grep ACCEPT | grep NEW | wc -l | xargs test 1 -eq",
    notify => Exec["ip-tables-save"]
  }

  exec { "open-port-49152":
    command     => "iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 49152:49261 -j ACCEPT",
    unless      => "iptables-save | grep 49152 | grep INPUT | grep ACCEPT | grep NEW | wc -l | xargs test 1 -eq",
    notify => Exec["ip-tables-save"]
  }
 
  exec { "ip-tables-save":
    command => "iptables-save > /etc/sysconfig/iptables",
    refreshonly => true,
    notify 	=> Service["iptables"],
  }

  service { "iptables":
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
  }

  service { "ip6tables":
    ensure      => stopped,
    enable      => false,
  }
}
