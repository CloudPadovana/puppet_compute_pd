class compute_pd::params {

# NOVA

# config_ssl - can be true or false
  $config_ssl		= true


  if $config_ssl {
    $auth_host		  = 'cloud-areapd.pd.infn.it'
    $auth_protocol        = 'https'
    $neutron_adm_auth_url = 'https://cloud-areapd.pd.infn.it:35357/v2.0'
    $novncproxy_base_url  = 'https://cloud-areapd.pd.infn.it:6080/vnc_auto.html'
    $glance_host          = 'cloud-areapd.pd.infn.it'
    $neutron_url          = 'https://cloud-areapd.pd.infn.it:9696'

    yumrepo { "EGI_CERT":
      baseurl => "http://repository.egi.eu/sw/production/cas/1/current/",
      descr => "EGI CERT repos",
      enabled => 1,
      gpgcheck => 0
    }

    package { 'ca_INFN-CA-2006':
      ensure => 'latest',
      require => Yumrepo["EGI_CERT"]
    }
    
    file { '/etc/grid-security/certificates/INFN-CA-2006.pem':
      ensure   => present,
      require    => Package["ca_INFN-CA-2006"],
    }

  } else {
    $auth_host            = '192.168.60.40'
    $auth_protocol        = 'http'
    $neutron_adm_auth_url = 'http://192.168.60.40:35357/v2.0'
    $novncproxy_base_url  = 'http://90.147.77.40:6080/vnc_auto.html'
    $glance_host          = '192.168.60.40'
    $neutron_url          = 'http://192.168.60.40:9696'
  }

  $cafile               = '/etc/grid-security/certificates/INFN-CA-2006.pem'
  $volume_glusterfs	= 'volume-nova-prod'
  $glance_api_servers   = 'https://cloud-areapd.pd.infn.it:9292'
  $glance_protocol      = 'https'
  $glance_api_insecure  = true
  $nova_db_conn		= 'mysql://nova_prod:XXXXXXXXXXXXXXX@192.168.60.10/nova_prod'
  $auth_strategy 	= 'keystone'
  $auth_port 		= '35357'
  $nova_admin_user 	= 'nova'
  $admin_tenant_name 	= 'services'
  $nova_admin_password	= 'XXXXXXX'
  $nova_rpc_backend 	= 'nova.openstack.common.rpc.impl_kombu'
  $rabbit_hosts 	= '192.168.60.100:5672,192.168.60.101:5672'
  $live_migration_flag 	= 'VIR_MIGRATE_UNDEFINE_SOURCE,VIR_MIGRATE_PEER2PEER,VIR_MIGRATE_LIVE'
#  $my_ip		= $::ipaddress_eth0
  $my_ip               = $::ip_manag
  $vnc_enabled 		= True
  $vncserver_listen 	= '0.0.0.0'
  $libvirt_vif_driver	= 'nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver'
#  $vncserver_pc_address = $::ipaddress_eth0
  $compute_driver 	= 'nova.virt.libvirt.LibvirtDriver'
  $nova_api_paste_conf 	= '/etc/nova/api-paste.ini'
  $network_api_class 	= 'nova.network.neutronv2.api.API'
  $neutron_admin_user	= 'neutron'
  $neutron_admin_pass	= 'XXXXXXXXX'
  $linuxnet_int_driver  = 'nova.network.linux_net.LinuxOVSInterfaceDriver'
  $security_group_api 	= 'neutron'
  $nova_firewall_driver = 'nova.virt.firewall.NoopFirewallDriver'
  $libvirt_inject_pass  = true
  $libvirt_inject_key 	= true
  $libvirt_inject_part	= '-1'
#metadata_shared_secret
  $neutron_md_p_sh_sec	= 'XXXXXXX'
  $rabbit_ha_queues 	= True
  $cpu_allocation_ratio = '4.0'
  $libvirt_cpu_mode 	= 'custom'
  $libvirt_cpu_model 	= 'kvm64'

# NOVA API-PASTE

  $paste_filter_factory	= 'keystoneclient.middleware.auth_token:filter_factory'

# NEUTRON

  $core_plugin 		= 'neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2'
  $neutron_api_paste_conf = '/etc/neutron/api-paste.ini'
  $neutron_rpc_backend	= 'neutron.openstack.common.rpc.impl_kombu'
  $root_helper 		= "sudo neutron-rootwrap /etc/neutron/rootwrap.conf"
  $neutron_db_conn	=  "mysql://neutron_prod:XXXXXXXXXXX@192.168.60.10/neutron_prod"
  $dhcp_agents_per_net	= 2
  $dhcp_lease_duration 	= 86400
  $agent_down_time      = 75
  $report_interval      = 30

# OVS_NEUTRON

  $tenant_network_type 	= 'gre'
  $tunnel_id_ranges 	= '1:1000'
  $enable_tunneling 	= True
  $integration_bridge 	= 'br-int'
  $tunnel_bridge 	= 'br-tun'
#  $local_ip 		= $::ipaddress_eth1
  $local_ip            = $::ip_data
  $neutron_firewall_driver = 'neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver'

# NEUTRON API-PASTE


}
