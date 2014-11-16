#!/bin/sh
#
# Nagios server
nagios_server="cld-nagios.cloud.pd.infn.it"
#
# Nagios client confifuration file
nagios_conf="/etc/nagios/send_nsca.cfg"
#
hostname=`/bin/hostname -s`
#
ovs_status=`/sbin/service openvswitch status | tr '\n' ';'`
ovs_status_retcode=$?
overall_msg=${ovs_status}
if [ $ovs_status_retcode -ne 0 ]; then
  echo -e "$hostname\tOpenvSwitch\t2\t${overall_msg}\n" | /usr/sbin/send_nsca -H ${nagios_server} -c ${nagios_conf}
  exit
fi

ovs_ofctl_out=`ovs-ofctl dump-flows br-tun`
if [[ ${ovs_ofctl_out} == *table=0* ]] && [[ ${ovs_ofctl_out} == *actions=resubmit* ]]; then
  overall_msg="${overall_msg} String 'table=0' 'actions=resubmit' found in ovs_ofctl outputput"
  retcode=0
else
  overall_msg="${overall_msg} Strings 'table=0' 'actions=resubmit' not found in ovs_ofctl outputput"
  retcode=2
fi
echo -e "$hostname\tOpenvSwitch\t${retcode}\t${overall_msg}\n" | /usr/sbin/send_nsca -H ${nagios_server} -c ${nagios_conf}

