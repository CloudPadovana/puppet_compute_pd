class compute_pd::configure {
   include compute_pd::params

   file { '/etc/nova/nova.conf':
	ensure	 => present,
	require    => Package["openstack-nova-common"],
   }

   file { '/etc/neutron/neutron.conf':
        ensure   => present,
        require    => Package["openstack-neutron-openvswitch"],
   }

   file { '/etc/nova/api-paste.ini':
        ensure   => present,
        require    => Package["openstack-nova-common"],
   }

   file { '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini':
        ensure   => present,
        require    => Package["openstack-neutron-openvswitch"],
   }

   file { '/etc/neutron/api-paste.ini':
        ensure   => present,
        require    => Package["openstack-neutron-openvswitch"],
   }

   define do_config ($conf_file, $section, $param, $value) {
	exec { "${name}":
		command     => "openstack-config --set ${conf_file} ${section} ${param} \"${value}\"",
		require     => Package['openstack-utils'],
		unless      => "openstack-config --get ${conf_file} ${section} ${param} 2>/dev/null | /bin/grep -- \"${value}\" 2>&1 >/dev/null",
	}
   }

   define remove_config ($conf_file, $section, $param, $value) {
        exec { "${name}":
                command     => "openstack-config --del ${conf_file} ${section} ${param}",
                require     => Package['openstack-utils'],
                onlyif      => "openstack-config --get ${conf_file} ${section} ${param} 2>/dev/null | /bin/grep -- \"${value}\" 2>&1 >/dev/null",
        }
   }

  if $compute_pd::params::config_ssl {
    do_config { 'nova_cafile': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'cafile', value => $compute_pd::params::cafile, }
    do_config { 'nova_neutron_ca_cert': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'neutron_ca_certificates_file', value => $compute_pd::params::cafile, }
    do_config { 'nova_cinder_ca_certificates_file': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'cinder_ca_certificates_file', value => $compute_pd::params::cafile, }
    do_config { 'neutron_ssl_ca_file': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'ssl_ca_file', value => $compute_pd::params::cafile, }
    do_config { 'nova_glance_prot': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'glance_protocol', value => $compute_pd::params::glance_protocol, }
    do_config { 'nova_glance_api_servers': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'glance_api_servers', value => $compute_pd::params::glance_api_servers, }
    do_config { 'nova_ssl_ca_file': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'ssl_ca_file', value => $compute_pd::params::cafile, }
    do_config { 'nova_glance_api_insecure': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'glance_api_insecure', value => $compute_pd::params::glance_api_insecure,} 
  } else {
    remove_config { 'nova_cafile': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'cafile', value => $compute_pd::params::cafile, }
    remove_config { 'nova_neutron_ca_cert': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'neutron_ca_certificates_file', value => $compute_pd::params::cafile, }
    remove_config { 'nova_cinder_ca_certificates_file': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'cinder_ca_certificates_file', value => $compute_pd::params::cafile, }
    remove_config { 'neutron_ssl_ca_file': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'ssl_ca_file', value => $compute_pd::params::cafile, }
    remove_config { 'nova_glance_prot': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'glance_protocol', value => $compute_pd::params::glance_protocol, }
    remove_config { 'nova_glance_api_servers': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'glance_api_servers', value => $compute_pd::params::glance_api_servers, }
    remove_config { 'nova_ssl_ca_file': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'ssl_ca_file', value => $compute_pd::params::cafile, }
    remove_config { 'nova_glance_api_insecure': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'glance_api_insecure', value => $compute_pd::params::glance_api_servers,}
  }

# nova.conf

  do_config { 'nova_db_conn': conf_file => '/etc/nova/nova.conf', section => 'database', param => 'connection', value => $compute_pd::params::nova_db_conn, } 
  do_config { 'nova_auth_host': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'auth_host', value => $compute_pd::params::auth_host, } 
  do_config { 'nova_auth_protocol': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'auth_protocol', value => $compute_pd::params::auth_protocol, }
  do_config { 'nova_auth_port': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'auth_port', value => $compute_pd::params::auth_port, }
  do_config { 'nova_admin_user': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'admin_user', value => $compute_pd::params::nova_admin_user, }
  do_config { 'nova_admin_tenant_name': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'admin_tenant_name', value => $compute_pd::params::admin_tenant_name, }
  do_config { 'nova_admin_password': conf_file => '/etc/nova/nova.conf', section => 'keystone_authtoken', param => 'admin_password', value => $compute_pd::params::nova_admin_password, }
  do_config { 'nova_rpc_backend': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'rpc_backend', value => $compute_pd::params::nova_rpc_backend, }
  do_config { 'nova_auth_strategy': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'auth_strategy', value => $compute_pd::params::auth_strategy}
  do_config { 'nova_rabbit_hosts': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'rabbit_hosts', value => $compute_pd::params::rabbit_hosts, }
  do_config { 'nova_live': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'live_migration_flag', value => $compute_pd::params::live_migration_flag, }
  do_config { 'nova_my_ip': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'my_ip', value => $compute_pd::params::my_ip, }
  do_config { 'nova_vnc': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'vnc_enabled', value => $compute_pd::params::vnc_enabled, }
  do_config { 'nova_vncserver': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'vncserver_listen', value => $compute_pd::params::vncserver_listen, }
  do_config { 'nova_libvirt_vif': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'libvirt_vif_driver', value => $compute_pd::params::libvirt_vif_driver, }
  do_config { 'nova_vncserver_proxy': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'vncserver_proxyclient_address', value => $compute_pd::params::my_ip, }
  do_config { 'nova_novncproxy': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'novncproxy_base_url', value => $compute_pd::params::novncproxy_base_url, }
  do_config { 'nova_glance': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'glance_host', value => $compute_pd::params::glance_host, }
  do_config { 'nova_compute_driver': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'compute_driver', value => $compute_pd::params::compute_driver, }
  do_config { 'nova_api_paste_conf': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'api_paste_config ', value => $compute_pd::params::nova_api_paste_conf, }
  do_config { 'nova_network_api': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'network_api_class', value => $compute_pd::params::network_api_class, }
  do_config { 'nova_neutron_url': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'neutron_url', value => $compute_pd::params::neutron_url, }
  do_config { 'nova_neutron_auth_strategy': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'neutron_auth_strategy', value => $compute_pd::params::auth_strategy, }
  do_config { 'nova_neutron_admin_tenant': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'neutron_admin_tenant_name', value => $compute_pd::params::admin_tenant_name, }
  do_config { 'nova_neutron_admin_user': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'neutron_admin_username', value => $compute_pd::params::neutron_admin_user, }
  do_config { 'nova_neutron_admin_pass': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'neutron_admin_password', value => $compute_pd::params::neutron_admin_pass, }
  do_config { 'nova_neutron_adm_auth_url': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'neutron_admin_auth_url', value => $compute_pd::params::neutron_adm_auth_url, }
  do_config { 'nova_linuxnet_int_driver': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'linuxnet_interface_driver', value => $compute_pd::params::linuxnet_int_driver, }
  do_config { 'nova_security_group_api': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'security_group_api', value => $compute_pd::params::security_group_api, }
  do_config { 'nova_firewall_driver': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'firewall_driver', value => $compute_pd::params::nova_firewall_driver, }
  do_config { 'nova_libvirt_inject_pass': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'libvirt_inject_password', value => $compute_pd::params::libvirt_inject_pass, }
  do_config { 'nova_libvirt_inject_key': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'libvirt_inject_key', value => $compute_pd::params::libvirt_inject_key, }
  do_config { 'nova_libvirt_inject_part': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'libvirt_inject_partition', value => $compute_pd::params::libvirt_inject_part, }
  do_config { 'nova_neutron_metadata_proxy_shared_secret': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'neutron_metadata_proxy_shared_secret', value => $compute_pd::params::neutron_md_p_sh_sec, }
  do_config { 'nova_rabbit_ha_queues': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'rabbit_ha_queues', value => $compute_pd::params::rabbit_ha_queues, }
  do_config { 'nova_cpu_allocation_ratio': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'cpu_allocation_ratio', value => $compute_pd::params::cpu_allocation_ratio, }
  do_config { 'nova_libvirt_cpu_mode': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'libvirt_cpu_mode', value => $compute_pd::params::libvirt_cpu_mode, }
  do_config { 'nova_libvirt_cpu_model': conf_file => '/etc/nova/nova.conf', section => 'DEFAULT', param => 'libvirt_cpu_model', value => $compute_pd::params::libvirt_cpu_model, }

# nova/api-paste.ini

  do_config { 'nova_api_paste': conf_file => '/etc/nova/api-paste.ini', section => 'filter:authtoken', param => 'paste.filter_factory', value => $compute_pd::params::paste_filter_factory, }
  do_config { 'nova_api_auth_host': conf_file => '/etc/nova/api-paste.ini', section => 'filter:authtoken', param => 'auth_host', value => $compute_pd::params::auth_host, }
  do_config { 'nova_api_auth_port': conf_file => '/etc/nova/api-paste.ini', section => 'filter:authtoken', param => 'auth_port', value => $compute_pd::params::auth_port, }
  do_config { 'nova_api_auth_protocol': conf_file => '/etc/nova/api-paste.ini', section => 'filter:authtoken', param => 'auth_protocol', value => $compute_pd::params::auth_protocol, }
  do_config { 'nova_api_admin_tenant_name': conf_file => '/etc/nova/api-paste.ini', section => 'filter:authtoken', param => 'admin_tenant_name', value => $compute_pd::params::admin_tenant_name, }
  do_config { 'nova_api_admin_user': conf_file => '/etc/nova/api-paste.ini', section => 'filter:authtoken', param => 'admin_user', value => $compute_pd::params::nova_admin_user, }
  do_config { 'nova_api_admin_pass': conf_file => '/etc/nova/api-paste.ini', section => 'filter:authtoken', param => 'admin_password', value => $compute_pd::params::nova_admin_password, }

# neutron.conf

  do_config { 'neutron_core_plugin': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'core_plugin', value => $compute_pd::params::core_plugin, }
  do_config { 'neutron_api_paste_conf': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'api_paste_config', value => $compute_pd::params::neutron_api_paste_conf, }
  do_config { 'neutron_rpc_backend': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'rpc_backend', value => $compute_pd::params::neutron_rpc_backend, }
  do_config { 'neutron_rabbit_hosts': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'rabbit_hosts', value => $compute_pd::params::rabbit_hosts, }
  do_config { 'neutron_auth_strategy': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'auth_strategy', value => $compute_pd::params::auth_strategy, }
  do_config { 'neutron_dhcp_agents_per_net': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'dhcp_agents_per_network', value => $compute_pd::params::dhcp_agents_per_net, }
  do_config { 'neutron_dhcp_lease_duration': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'dhcp_lease_duration', value => $compute_pd::params::dhcp_lease_duration, }
  do_config { 'neutron_rabbit_ha_queues': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'rabbit_ha_queues', value => $compute_pd::params::rabbit_ha_queues, }
  do_config { 'neutron_auth_host': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'auth_host', value => $compute_pd::params::auth_host, }
  do_config { 'neutron_admin_user': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'admin_user', value => $compute_pd::params::neutron_admin_user, }
  do_config { 'neutron_admin_pass': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'admin_password', value => $compute_pd::params::neutron_admin_pass, }
  do_config { 'neutron_auth_url': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'auth_url', value => $compute_pd::params::neutron_adm_auth_url, }
  do_config { 'neutron_admin_tenant_name': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'admin_tenant_name', value => $compute_pd::params::admin_tenant_name, }
  do_config { 'neutron_agent_root_helper': conf_file => '/etc/neutron/neutron.conf', section => 'agent', param => 'root_helper', value => $compute_pd::params::root_helper, }
  do_config { 'neutron_db_conn': conf_file => '/etc/neutron/neutron.conf', section => 'database', param => 'connection', value => $compute_pd::params::neutron_db_conn, }
  do_config { 'neutron_auth_protocol': conf_file => '/etc/neutron/neutron.conf', section => 'keystone_authtoken', param => 'auth_protocol', value => $compute_pd::params::auth_protocol, }
  do_config { 'neutron_agent_dt': conf_file => '/etc/neutron/neutron.conf', section => 'DEFAULT', param => 'agent_down_time', value => $compute_pd::params::agent_down_time, }
  do_config { 'neutron_report_interval': conf_file => '/etc/neutron/neutron.conf', section => 'agent', param => 'report_interval', value => $compute_pd::params::report_interval, }


# neutron/ovs_neutron_plugin

  do_config { 'neutron_ovs_tenant_network_type': conf_file => '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini', section => 'ovs', param => 'tenant_network_type', value => $compute_pd::params::tenant_network_type, }
  do_config { 'neutron_ovs_tunnel_id_ranges': conf_file => '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini', section => 'ovs', param => 'tunnel_id_ranges', value => $compute_pd::params::tunnel_id_ranges, }
  do_config { 'neutron_ovs_enable_tunneling': conf_file => '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini', section => 'ovs', param => 'enable_tunneling', value => $compute_pd::params::enable_tunneling, }
  do_config { 'neutron_ovs_integration_bridge': conf_file => '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini', section => 'ovs', param => 'integration_bridge', value => $compute_pd::params::integration_bridge, }
  do_config { 'neutron_ovs_tunnel_bridge': conf_file => '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini', section => 'ovs', param => 'tunnel_bridge', value => $compute_pd::params::tunnel_bridge, }
  do_config { 'neutron_ovs_local_ip': conf_file => '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini', section => 'ovs', param => 'local_ip', value => $compute_pd::params::local_ip, }
  do_config { 'neutron_ovs_sec_': conf_file => '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini', section => 'securitygroup', param => 'firewall_driver', value => $compute_pd::params::neutron_firewall_driver, }

## remember ln

# neutron/api-paste

  do_config { 'neutron_api_paste': conf_file => '/etc/neutron/api-paste.ini', section => 'filter:authtoken', param => 'paste.filter_factory', value => $compute_pd::params::paste_filter_factory, }
  do_config { 'neutron_api_auth_host': conf_file => '/etc/neutron/api-paste.ini', section => 'filter:authtoken', param => 'auth_host', value => $compute_pd::params::auth_host, }
  do_config { 'neutron_api_admin_tenant_name': conf_file => '/etc/neutron/api-paste.ini', section => 'filter:authtoken', param => 'admin_tenant_name', value => $compute_pd::params::admin_tenant_name, }
  do_config { 'neutron_api_admin_user': conf_file => '/etc/neutron/api-paste.ini', section => 'filter:authtoken', param => 'admin_user', value => $compute_pd::params::neutron_admin_user, }
  do_config { 'neutron_api_admin_pass': conf_file => '/etc/neutron/api-paste.ini', section => 'filter:authtoken', param => 'admin_password', value => $compute_pd::params::neutron_admin_pass, }

#   Do_config ['nova_db_conn'] -> Do_config ['nova_auth_strategy']

}
