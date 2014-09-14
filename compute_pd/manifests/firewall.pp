class compute_pd::firewall {

#    exec { "purge default firewall":
#        command => "/sbin/iptables -F && /sbin/iptables-save > /etc/sysconfig/iptables && /sbin/service iptables restart",
#        onlyif  => "/usr/bin/test `/bin/grep \"Firewall configuration written by\" /etc/sysconfig/iptables | /usr/bin/wc -l` -gt 0",
#        user    => 'root',
#    }
 
##    /* Make the firewall persistent */
#    exec { "persist-firewall":
#        command     => "/bin/echo \"# This file is managed by puppet. Do not modify manually.\" > /etc/sysconfig/iptables && /sbin/iptables-save >> /etc/sysconfig/iptables", 
#        refreshonly => true,
#        user        => 'root',
#    }
 
#    firewall { '000 INPUT allow related and established':
#        state => ['RELATED', 'ESTABLISHED'],
#        action => 'accept',
#        proto => 'all',
#    }

#    firewall { "001 accept all icmp requests":
#        proto => 'icmp',
#        action  => 'accept',
#    }
 
#    firewall { '002 INPUT allow loopback':
#        iniface => 'lo',
#        chain   => 'INPUT',
#        action => 'accept',
#    }
 
#    firewall { '100 allow ssh':
#    	state => ['NEW'],
#    	proto => 'tcp',
#    	dport => '22',
#        action => 'accept',
#    }

    firewall { '100 allow VNC':
    	state => ['NEW'],
    	proto => 'tcp',
    	dport => '5900-5999',
        action => 'accept',
    }

    firewall { '101 allow libvirtd TCP ports':
        state => ['NEW'],
        proto => 'tcp',
        dport => '16509',
        action => 'accept',
    }

    firewall { '102 libvirtd ephemeral ports':
        state => ['NEW'],
        proto => 'tcp',
        dport => '49152-49261',
        action => 'accept',
    }


#    firewall { "998 deny all other requests":
#        action   => 'reject',
#        proto  => 'all',
#        reject => 'icmp-host-prohibited',
#    }
 
#    firewall { "999 deny all other requests":
#        chain  => 'FORWARD',
#        action   => 'reject',
#        proto  => 'all',
#        reject => 'icmp-host-prohibited',
#    }

}
