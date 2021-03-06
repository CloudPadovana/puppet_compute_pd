class compute_pd {

# TODO params.pp per OSfamily
  include compute_pd::params

# install
  class {'compute_pd::install':}

# setup firewall
  class {'compute_pd::firewall':}

# setup libvirt
  class {'compute_pd::libvirt':}

# do configuration
  class {'compute_pd::configure':}

# do passwdless access
  class {'compute_pd::pwl_access':}

# disable SELinux

  exec { "setenforce 0":
    path	=> "/bin:/sbin:/usr/bin:/usr/sbin",
    onlyif	=> "which setenforce && getenforce | grep Enforcing",
  }

# setup sysctl

  Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

  Sysctl {
    notify	=> Exec["load-sysctl"],
    require	=> Class['compute_pd::libvirt'],
  }  

  $my_sysctl_settings = {
    "net.ipv4.conf.all.rp_filter"     => { value => 0 },
    "net.ipv4.conf.default.rp_filter" => { value => 0 },
  }

  create_resources(sysctl::value,$my_sysctl_settings)

  exec { load-sysctl:
    command	=> "/sbin/sysctl -p /etc/sysctl.conf",
    refreshonly => true
  }

# Files needed

  file {'metadata_agent':
    source	=> 'puppet:///modules/compute_pd/agent.py',
    path	=> '/usr/lib/python2.6/site-packages/neutron/agent/metadata/agent.py',
    backup	=> true,
    notify	=> [ Service["neutron-openvswitch-agent"], Service["openstack-nova-compute"] ],
    require	=> Package['openstack-neutron-openvswitch'],
    subscribe	=> Class['compute_pd::configure'],
  }

  file {'/etc/neutron/plugin.ini':
    ensure	=> link,
    target	=> '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini',
    require	=> Package['openstack-neutron-openvswitch']
  }


  file {'nagios_check_ovs':
     source      => 'puppet:///modules/compute_pd/nagios_check_ovs.sh',
     path	 => '/usr/local/bin/nagios_check_ovs.sh',
     mode	 => '+x',
     subscribe   => Class['compute_pd::configure'],
  }

  file {'nagios_check_kvm':
     source      => 'puppet:///modules/compute_pd/check_kvm',
     path        => '/usr/local/bin/check_kvm',
     mode        => '+x',
     subscribe   => Class['compute_pd::configure'],
  }

  file {'nagios_check_kvm_wrapper':
     source      => 'puppet:///modules/compute_pd/check_kvm_wrapper.sh',
     path        => '/usr/local/bin/check_kvm_wrapper.sh',
     mode        => '+x',
     require	 => File['nagios_check_kvm'],
     subscribe   => Class['compute_pd::configure'],
  }

# Services needed

  service { "openvswitch":
    ensure	=> running,
    enable	=> true,
    hasstatus	=> true,
    hasrestart	=> true,
    require	=> Package["openstack-neutron-openvswitch"],
    subscribe	=> Class['compute_pd::configure'],
  }

  service { "neutron-openvswitch-agent":
    ensure	=> running,
    enable	=> true,
    hasstatus	=> true,
    hasrestart	=> true,
    require	=> Package["openstack-neutron-openvswitch"],
    subscribe	=> Class['compute_pd::configure'],
  }

  service { "neutron-ovs-cleanup":
    enable	=> true,
    require	=> Package["openstack-neutron-openvswitch"],
  }

  service { "messagebus":
    ensure	=> running,
    enable	=> true,
    hasstatus	=> true,
    hasrestart	=> true,
    require	=> Package["libvirt"],
    subscribe	=> Class['compute_pd::configure'],
  }

  service { "openstack-nova-compute":
    ensure	=> running,
    enable	=> true,
    hasstatus	=> true,
    hasrestart	=> true,
    require	=> Package["openstack-nova-compute"],
    subscribe	=> Class['compute_pd::configure'],
  }

  exec { 'create_bridge':
    command	=> "ovs-vsctl add-br br-int",
    unless	=> "ovs-vsctl br-exists br-int",
    require	=> Service["openvswitch"],
  }  


# mount glusterfs volume

  file { 'nova-instances':
    path	=> "/var/lib/nova/instances",
    ensure	=> directory,
    require	=> Package["openstack-nova-common"],
  }
  
  mount { "/var/lib/nova/instances":
    ensure	=> mounted,
    device	=> "192.168.61.100:/$compute_pd::params::volume_glusterfs",
    atboot	=> true,
    fstype	=> "glusterfs",
    options	=> "defaults,log-level=ERROR,_netdev,backup-volfile-servers=192.168.61.101",
    require	=> [ File["nova-instances"], Package ["glusterfs-fuse"] ]
  }


# NAGIOS - various crontabs

 cron {'nagios_check_ovs':
    ensure	=> present,
    command	=> "/usr/local/bin/nagios_check_ovs.sh",
    user	=> root,
    minute	=> 0,
    hour	=> '*/1',
    require	=> File["nagios_check_ovs"]
  }

  cron {'nagios_check_kvm':
    ensure     => present,
    command    => "/usr/local/bin/check_kvm_wrapper.sh",
    user       => root,
    minute	=> 0,
    hour	=> '*/1',
    require    => File["nagios_check_kvm_wrapper"]
  }


# execution order

  Class['compute_pd::firewall'] -> Class['compute_pd::install']
  Class['compute_pd::install'] -> Class['compute_pd::configure']
  Class['compute_pd::configure'] -> File['/etc/neutron/plugin.ini']
  Class['compute_pd::configure'] -> Cron['nagios_check_ovs']
  Class['compute_pd::configure'] -> Cron['nagios_check_kvm']
  Class['compute_pd::configure'] -> Class['compute_pd::pwl_access']
  Service["openvswitch"] -> Exec['create_bridge']



}
