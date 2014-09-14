class compute_pd::install {
  $selinux = True

  $computepackages = [ "openstack-nova-compute", 
			"openstack-utils", 
			"openstack-neutron-openvswitch", 
			"sysfsutils", 
			"openstack-nova-common" ]
  package { $computepackages: ensure => "installed" }

#  yumrepo { "EGI_CERT":
#      baseurl => "http://repository.egi.eu/sw/production/cas/1/current/",
#      descr => "EGI CERT repos",
#      enabled => 1,
#      gpgcheck => 0
#   }

#  package { 'ca_INFN-CA-2006':
#	ensure => 'installed',
#	require => Yumrepo["EGI_CERT"]
#  }
}
