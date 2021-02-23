#!/bin/bash
tripwire --check |grep -vEi 'Wrote report file|Report created on' > /utils/tripwire/current_status/tripwire_check_out
EMAIL=mail_id
# Checking tripwire.service
/bin/diff /utils/tripwire/default/tripwire_check_out /utils/tripwire/current_status/tripwire_check_out >/utils/tripwire/diff/tripwire_check_out_diff
if [ $? -eq 1 ] ; then
mail -s "`hostname -s` - tripwire. alert" -r tripwire_admin $EMAIL </utils/tripwire/diff/tripwire_check_out_diff
fi




root@zzzcokltvpn02:/utils/BAK/monitor/bin# cat monitor.script
#!/bin/bash
# this script will monitor the services or process

echo "`date` : script execution started" >> /utils/monitor/logs/monitor.log ;

# Email lists - emails separated by comma ,
EMAIL=avinash.raghu@zeazonz.com

# root
if [ $(id -u) != "0" ]; then
    echo "You must be login as root to execute this script"
    exit 1
fi

#/bin/ps -ef |/bin/grep -v grep |/bin/grep goipclient1_sg.conf|/bin/awk '{print $2}' >/utils/monitor/current_status/pid_vpn-zzz-sg
#/bin/ps -ef |/bin/grep -v grep |/bin/grep goipclient1_in.conf|/bin/awk '{print $2}' >/utils/monitor/current_status/pid_vpn-zzz-in
#/bin/ps -ef |/bin/grep -v grep |/bin/grep firewalld |/bin/awk '{print $2}' >/utils/monitor/current_status/pid_firewalld
#/bin/ps -ef |/bin/grep -v grep |/bin/grep httpd |/bin/grep root |/bin/awk '{print $2}' >/utils/monitor/current_status/pid_httpd
#/bin/ps -ef |/bin/grep -v grep |/bin/grep mysqld |/bin/awk '{print $2}' >/utils/monitor/current_status/pid_mysqld
/bin/ps -ef |/bin/grep -v grep |/bin/grep tripwire |/bin/awk '{print $2}'>/utils/monitor/current_status/pid_tripwire_status



/bin/df -hT |/bin/grep -v tmpfs |awk '{print $1 " " $2 " " $7}'>/utils/monitor/current_status/df_exclude_tmpfs
/bin/systemctl list-unit-files |/bin/grep enabled >/utils/monitor/current_status/systemctl_enabled
/bin/df -hT / |/bin/awk '{print $6}' |/bin/grep -v "Use%" |/bin/sed 's/%//g' >/utils/monitor/current_status/df-hT_usage
/bin/df -hT / >/utils/monitor/current_status/df-hT_status

#/bin/firewall-cmd --list-all-zones >/utils/monitor/current_status/firewall-cmd_status
#/sbin/ip route show >/utils/monitor/current_status/ip_route_show_status

# Comparing the status

# Check External IP
externalip=$(curl -s ipecho.net/plain;echo) && echo -e '\E[32m'"External IP : $tecreset "$externalip > /tmp/exten_ip
internalip=$(hostname -I) && echo -e '\E[32m'"Internal IP :" $tecreset $internalip >> /tmp/exten_ip
mail -s "`date` :`hostname -s` - external_IP" -r monitor_admin $EMAIL </tmp/exten_ip
rm -rf /tmp/exten_ip


/bin/diff /utils/monitor/default/pid_tripwire_status /utils/monitor/current_status/pid_tripwire_status >/utils/monitor/diff/pid_tripwire_status_diff
if [ $? -gt 0 ] ; then
echo "`date` :There is a change in the tripwire rules" | mail -s "`date` :`hostname -s` - change tripwire pid process" -r monitor_admin $EMAIL </utils/monitor/diff/pid_tripwire_status_diff
fi;




# Checking vpn-zzz-sg.service
#/bin/diff /utils/monitor/default/pid_vpn-zzz-sg /utils/monitor/current_status/pid_vpn-zzz-sg >/utils/monitor/diff/pid_vpn-zzz-sg_diff
#if [ $? -gt 0 ] ; then
#echo "`date` :There is something wrong with vpn-zzz-sg.service " | mail -s "`date` :`hostname -s` - vpn-zzz-sg.service issue" -r monitor_admin $EMAIL </utils/monitor/diff/pid_vpn-zzz-sg_diff
#fi;

# Checking vpn-zzz-in.service
#/bin/diff /utils/monitor/default/pid_vpn-zzz-in /utils/monitor/current_status/pid_vpn-zzz-in >/utils/monitor/diff/pid_vpn-zzz-in_diff
#if [ $? -gt 0 ] ; then
#echo "`date` :There is something wrong with vpn-zzz-in.service " | mail -s "`date` :`hostname -s` - vpn-zzz-in.service issue" -r monitor_admin $EMAIL </utils/monitor/diff/pid_vpn-zzz-in_diff
#fi;

# Checking firewalld.service
#/bin/diff /utils/monitor/default/pid_firewalld /utils/monitor/current_status/pid_firewalld >/utils/monitor/diff/pid_firewalld_diff
#if [ $? -gt 0 ] ; then
#echo "`date` :There is something wrong with firewalld.service " | mail -s "`date` :`hostname -s` - firewalld.service issue" -r monitor_admin $EMAIL </utils/monitor/diff/pid_firewalld_diff
#fi;

# Checking firewall rules for any changes
#/bin/diff /utils/monitor/default/firewall-cmd_status /utils/monitor/current_status/firewall-cmd_status >/utils/monitor/diff/firewall-cmd_status_diff
#if [ $? -gt 0 ] ; then
#echo "`date` :There is a change in the firewall rules" | mail -s "`date` :`hostname -s` - change in the firewall rules" -r monitor_admin $EMAIL </utils/monitor/diff/firewall-cmd_status_diff
#fi;

# Checking httpd.service
#/bin/diff /utils/monitor/default/pid_httpd /utils/monitor/current_status/pid_httpd >/utils/monitor/diff/pid_httpd_diff
#if [ $? -gt 0 ] ; then
#echo "`date` :There is something wrong with httpd.service " | mail -s "`date` :`hostname -s` - httpd.service issue" -r monitor_admin $EMAIL </utils/monitor/diff/pid_httpd_diff
#fi;

# Checking mysqld.service mariadb
#/bin/diff /utils/monitor/default/pid_mysqld /utils/monitor/current_status/pid_mysqld >/utils/monitor/diff/pid_mysqld_diff
#if [ $? -gt 0 ] ; then
#echo "`date` :There is something wrong with mysqld.service " | mail -s "`date` :`hostname -s` - mysqld.service issue" -r monitor_admin $EMAIL </utils/monitor/diff/pid_mysqld_diff
#fi;

# Checking mount status
/bin/diff /utils/monitor/default/df_exclude_tmpfs /utils/monitor/current_status/df_exclude_tmpfs >/utils/monitor/diff/df_exclude_tmpfs_diff
if [ $? -gt 0 ] ; then
echo "`date` :There is something wrong with mount points" | mail -s "`date` :`hostname -s` - mount point issue" -r monitor_admin $EMAIL </utils/monitor/diff/df_exclude_tmpfs_diff
fi;

# Checking the total systemctl enabled service
/bin/diff /utils/monitor/default/systemctl_enabled /utils/monitor/current_status/systemctl_enabled >/utils/monitor/diff/systemctl_enabled_diff
if [ $? -gt 0 ] ; then
echo "`date` :There is something wrong with total systemctl enabled service" | mail -s "`date` :`hostname -s` - Total systemctl enabled service issue" -r monitor_admin $EMAIL </utils/monitor/diff/systemctl_enabled_diff
fi;

# Checking the df -hT for /
THRESHOLD_DF=98
CURRENT_DF=`cat /utils/monitor/current_status/df-hT_usage`
if [ $CURRENT_DF -ge $THRESHOLD_DF ] ; then
echo "`date` : / df -hT usage is $THRESHOLD_DF% or higher. Check immediately the / usage" | mail -s "`date` :`hostname -s` - df -hT usage is THRESHOLD_DF=98% or higher" -r monitor_admin $EMAIL </utils/monitor/current_status/df-hT_status
fi;

# checking goip sg
#ping -c2 -s 0 192.168.254.252 >/utils/monitor/current_status/goip_sg_status
#if [ $? -gt 0 ] ; then
#echo "Critical! `date` :Goip device SG or network is DOWN . Unable to ping from sip1sg to goipsg 192.168.254.252" | mail -s "Critical! `date` :`hostname -s` - Goip device SG is DOWN" -r monitor_admin $EMAIL </utils/monitor/current_status/goip_sg_status
#fi;
# checking goip1in
#ping -c2 -s 0 192.168.120.250 >/utils/monitor/current_status/goip1_in_status
#if [ $? -gt 0 ] && [ ! -f "/utils/monitor/control_alarm/disable_goip1in_alarm" ] ; then
#echo "Critical! `date` :Goip1 device IN or network is DOWN . Unable to ping from sip1sg to goip1in 192.168.120.250" | mail -s "Critical! `date` :`hostname -s` - Goip1 device IN is DOWN" -r monitor_admin $EMAIL </utils/monitor/current_status/goip1_in_status
#fi;
# checking goip2in
#ping -c2 -s 0 192.168.121.250 >/utils/monitor/current_status/goip2_in_status
#if [ $? -gt 0 ] && [ ! -f "/utils/monitor/control_alarm/disable_goip2in_alarm" ] ; then
#echo "Critical! `date` :Goip2 device IN or network is DOWN . Unable to ping from sip1sg to goip2in 192.168.121.250" | mail -s "Critical! `date` :`hostname -s` - Goip2 device IN is DOWN" -r monitor_admin $EMAIL </utils/monitor/current_status/goip2_in_status
#fi;

# Checking ip route show
#/bin/diff /utils/monitor/default/ip_route_show_status /utils/monitor/current_status/ip_route_show_status >/utils/monitor/diff/ip_route_show_status_diff
#if [ $? -gt 0 ] ; then
#echo "`date` ;sip1sg : network route is different.Check ip route show " | mail -s "`date`:`hostname -s` - network route is different" -r monitor_admin $EMAIL </utils/monitor/diff/ip_route_show_status_diff
#fi;

# changing the permission to tux:tux for clearing alarms
#/bin/chown -R debug:debug /utils/monitor/current_status /utils/monitor/default

echo "`date` : script execution completed" >> /utils/monitor/logs/monitor.log ;
