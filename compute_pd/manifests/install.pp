class compute_pd::install {
  $selinux = True

  $computepackages = [ "openstack-nova-compute", 
			"openstack-utils", 
			"openstack-neutron-openvswitch", 
			"sysfsutils", 
			"openstack-nova-common" ]
  package { $computepackages: ensure => "installed" }

  yumrepo { "glusterfs-epel":
    baseurl		=> "http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/epel-$::operatingsystemrelease/$::architecture/",
    descr		=> "GlusterFS is a clustered file-system capable of scaling to several petabytes",
    enabled		=> 1,
    gpgcheck		=> 1,
#    skip_if_unavailable => 1,
    gpgkey		=> 'http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/pub.key',
  }

  yumrepo { "glusterfs-noarch-epel":
    baseurl             => "http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/epel-$::operatingsystemrelease/noarch/",
    descr               => "GlusterFS is a clustered file-system capable of scaling to several petabytes",
    enabled             => 1,
    gpgcheck            => 1,
#    skip_if_unavailable => 1,
    gpgkey              => 'http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/pub.key',
  }

  package { 'glusterfs-fuse':
       ensure => 'installed',
       require => [ Yumrepo["glusterfs-epel"], Yumrepo["glusterfs-noarch-epel"] ]
  }

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
