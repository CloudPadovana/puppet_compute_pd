class compute_pd::nova_config {
   include compute_pd::params

   file { '/etc/nova/nova.conf':
	ensure	 => present,
	require    => Package["openstack-nova-common"],
   }


   exec { 'config_nova_db_conn':
      command     => "openstack-config --set /etc/nova/nova.conf database connection \"$compute_pd::params::nova_db_conn\"",
      require     => [ File['/etc/nova/nova.conf'], Package['openstack-utils'] ],
      unless      => "openstack-config --get /etc/nova/nova.conf database connection 2>/dev/null | /bin/grep \"$compute_pd::params::nova_db_conn\" 2>&1 >/dev/null",
   }


   exec { 'config_nova_auth_strategy':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT auth_strategy $compute_pd::params::auth_strategy",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT auth_strategy 2>/dev/null | /bin/grep $compute_pd::params::auth_strategy 2>&1 >/dev/null",
      require     => Exec["config_nova_db_conn"],
   }   

   exec { 'config_nova_auth_host':
      command     => "openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_host $compute_pd::params::auth_host",
      unless      => "openstack-config --get /etc/nova/nova.conf keystone_authtoken auth_host 2>/dev/null | /bin/grep $compute_pd::params::auth_port 2>&1 >/dev/null",
      require     => Exec["config_nova_auth_strategy"],
   }

   exec { 'config_nova_auth_protocol':
      command     => "openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_protocol $compute_pd::params::auth_protocol",
      unless      => "openstack-config --get /etc/nova/nova.conf keystone_authtoken auth_protocol 2>/dev/null | /bin/grep $compute_pd::params::auth_protocol 2>&1 >/dev/null",
      require     => Exec["config_nova_auth_host"],
   }

   exec { 'config_nova_auth_port':
      command     => "openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_port $compute_pd::params::auth_port",
      unless      => "openstack-config --get /etc/nova/nova.conf keystone_authtoken auth_protocol 2>/dev/null | /bin/grep $compute_pd::params::auth_port 2>&1 >/dev/null",
      require     => Exec["config_nova_auth_protocol"],
   }

   exec { 'config_nova_admin_user':
      command     => "openstack-config --set /etc/nova/nova.conf keystone_authtoken admin_user $compute_pd::params::admin_user",
      unless      => "openstack-config --get /etc/nova/nova.conf keystone_authtoken admin_user 2>/dev/null | /bin/grep $compute_pd::params::admin_user 2>&1 >/dev/null",
      require     => Exec["config_nova_auth_port"],
   }

   exec { 'config_nova_admin_tenant_name':
      command     => "openstack-config --set /etc/nova/nova.conf keystone_authtoken admin_tenant_name $compute_pd::params::admin_tenant_name",
      unless      => "openstack-config --get /etc/nova/nova.conf keystone_authtoken admin_tenant_name 2>/dev/null | /bin/grep $compute_pd::params::admin_tenant_name 2>&1 >/dev/null",
      require     => Exec["config_nova_admin_user"],
   }

   exec { 'config_nova_admin_password':
      command     => "openstack-config --set /etc/nova/nova.conf keystone_authtoken admin_password $compute_pd::params::nova_admin_password",
      unless      => "openstack-config --get /etc/nova/nova.conf keystone_authtoken admin_password 2>/dev/null | /bin/grep $compute_pd::params::nova_admin_password 2>&1 >/dev/null",
      require     => Exec["config_nova_admin_tenant_name"],
   }

   exec { 'config_nova_rpc_backend':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT rpc_backend $compute_pd::params::nova_rpc_backend",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT rpc_backend 2>/dev/null | /bin/grep $compute_pd::params::nova_rpc_backend 2>&1 >/dev/null",
      require     => Exec["config_nova_admin_password"],
   }

   exec { 'config_nova_rabbit_hosts':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT rabbit_hosts $compute_pd::params::rabbit_hosts",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT rabbit_hosts 2>/dev/null | /bin/grep $compute_pd::params::rabbit_hosts 2>&1 >/dev/null",
      require     => Exec["config_nova_rpc_backend"],
   }

   exec { 'config_nova_migr_flag':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT live_migration_flag $compute_pd::params::live_migration_flag",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT live_migration_flag 2>/dev/null | /bin/grep $compute_pd::params::live_migration_flag 2>&1 >/dev/null",
      require     => Exec["config_nova_rabbit_hostss"],
   }

   exec { 'config_nova_my_ip':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT my_ip $compute_pd::params::my_ip",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT my_ip 2>/dev/null | /bin/grep $compute_pd::params::my_ip 2>&1 >/dev/null",
      require     => Exec["config_nova_migr_flag"],
   }

   exec { 'config_nova_vnc':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT vnc_enabled $compute_pd::params::vnc_enabled",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT vnc_enabled 2>/dev/null | /bin/grep $compute_pd::params::vnc_enabled 2>&1 >/dev/null",
      require     => Exec["config_nova_my_ip"],
   }

   exec { 'config_nova_vncserver':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT vncserver_listen $compute_pd::params::vncserver_listen",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT vncserver_listen 2>/dev/null | /bin/grep $compute_pd::params::vncserver_listen 2>&1 >/dev/null",
      require     => Exec["config_nova_vnc"],
   }

   exec { 'config_nova_libvirt_vif':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT libvirt_vif_driver $compute_pd::params::libvirt_vif_driver",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT libvirt_vif_driver 2>/dev/null | /bin/grep $compute_pd::params::vncserver_listen 2>&1 >/dev/null",
      require     => Exec["config_nova_vncserver"],
   }

   exec { 'config_nova_vncserver_proxy':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT vncserver_proxyclient_address $compute_pd::params::my_ip",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT vncserver_proxyclient_address 2>/dev/null | /bin/grep $compute_pd::params::my_ip 2>&1 >/dev/null",
      require     => Exec["config_nova_libvirt_vif"],
   }

   exec { 'config_nova_novnc':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT novncproxy_base_url $compute_pd::params::novncproxy_base_url",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT novncproxy_base_url 2>/dev/null | /bin/grep $compute_pd::params::novncproxy_base_url 2>&1 >/dev/null",
      require     => Exec["config_nova_vncserver_proxy"],
   }

   exec { 'config_nova_glance_host':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT glance_host $compute_pd::params::glance_host",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT glance_host 2>/dev/null | /bin/grep $compute_pd::params::glance_host 2>&1 >/dev/null",
      require     => Exec["config_nova_novnc"],
   }

   exec { 'config_nova_compute_driver':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT compute_driver $compute_pd::params::compute_driver",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT compute_driver 2>/dev/null | /bin/grep $compute_pd::params::compute_driver 2>&1 >/dev/null",
      require     => Exec["config_nova_glance_host"],
   }

   exec { 'config_nova_api_paste':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT api_paste_config $compute_pd::params::api_paste_config",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT api_paste_config 2>/dev/null | /bin/grep $compute_pd::params::api_paste_config 2>&1 >/dev/null",
      require     => Exec["config_nova_compute_driver"],
   }

   exec { 'config_nova_network_api':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT network_api_class $compute_pd::params::network_api_class",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT network_api_class 2>/dev/null | /bin/grep $compute_pd::params::network_api_class 2>&1 >/dev/null",
      require     => Exec["config_nova_api_paste"],
   }

   exec { 'config_nova_neutron_url':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT neutron_url $compute_pd::params::neutron_url",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT neutron_url 2>/dev/null | /bin/grep $compute_pd::params::neutron_url 2>&1 >/dev/null",
      require     => Exec["config_nova_neutron_api"],
   }   

   exec { 'config_nova_neutron_auth_strategy':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT neutron_auth_strategy $compute_pd::params::auth_strategy",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT neutron_auth_strategy 2>/dev/null | /bin/grep $compute_pd::params::auth_strategy: 2>&1 >/dev/null",
      require     => Exec["config_nova_neutron_url"],
   }

   exec { 'config_nova_neutron_admin_tenant':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT neutron_admin_tenant_name $compute_pd::params::admin_tenant_name",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT neutron_admin_tenant_name 2>/dev/null | /bin/grep $compute_pd::params::admin_tenant_name 2>&1 >/dev/null",
      require     => Exec["config_nova_neutron_auth_strategy"],
   }

   exec { 'config_nova_neutron_admin_user':
      command     => "openstack-config --set /etc/nova/nova.conf DEFAULT neutron_admin_username $compute_pd::params::neutron_admin_username",
      unless      => "openstack-config --get /etc/nova/nova.conf DEFAULT neutron_admin_username 2>/dev/null | /bin/grep $compute_pd::params::neutron_admin_username 2>&1 >/dev/null",
      require     => Exec["config_nova_neutron_admin_tenant"],
   }

}
