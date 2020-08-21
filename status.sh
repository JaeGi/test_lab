#!/bin/bash

clear

HOSTNAME=$(hostname)
CPUCORE=$(cat /proc/cpuinfo | grep processor| wc -l)
CPUUSAGE=$( top -b -n1 | grep -Po '[0-9.]+ id' | awk '{print 100-$1}')
#MEMTOTAL=$(dmidecode | grep 'Size.*MB' | awk -F ":" '{print $2}')
MEMTOTAL=$(cat /proc/meminfo | grep MemTotal| awk -F " " '{print $2, $3}')
MEMUSAGE=$(free | awk '/Mem/{printf("RAM Usage: %.2f\n"), $3/$2*100}'| awk '{print $3}')
OSVERSION=$(cat /etc/redhat-release | awk -F " " '{print $1, $2, $3, $4, $5, $7}')
KERNELVERSION=$(uname -r)
SELINUX=$(getenforce)
DATE=$(date +%Y-%M-%d)
ALLOW=$(cat /etc/hosts.allow | grep -v '#')
DENY=$(cat /etc/hosts.deny | grep -v '#')
NTP_RPM=$(rpm -qa | grep ntp)


rm -rf /home/sysmgmt/AS-IS_$HOSTNAME

echo "----------------------"  >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "WORK DATE : $DATE" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo -e "----------------------\n" >> /home/sysmgmt/AS-IS_$HOSTNAME

echo "1. OS & Kernel Version " >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "---------------------- " >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "OS     Version : $OSVERSION" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "Kernel Version : $KERNELVERSION" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "" >> /home/sysmgmt/AS-IS_$HOSTNAME

echo "2. SELinux Status : $SELINUX"  >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "---------------------- " >> /home/sysmgmt/AS-IS_$HOSTNAME
sestatus >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "" >> /home/sysmgmt/AS-IS_$HOSTNAME

echo "3. CPU Core and CPU Usage" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "----------------------------" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "CPU Core  : $CPUCORE  EA " >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "CPU Usage : $CPUUSAGE %  " >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "" >> /home/sysmgmt/AS-IS_$HOSTNAME

echo "4. MEM Total and MEM Usage" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "-----------------------" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "MEM Total : $MEMTOTAL" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "MEM Usage : $MEMUSAGE %" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "" >> /home/sysmgmt/AS-IS_$HOSTNAME

echo "5. Disk Usage (Remove TMPFS)" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "-------------" >> /home/sysmgmt/AS-IS_$HOSTNAME
df -hP | grep -v tmpfs >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "" >> /home/sysmgmt/AS-IS_$HOSTNAME

rpm -qa | grep ntp
if [ $? -eq 0 ]; then

        echo "" >> /home/sysmgmt/AS-IS_$HOSTNAME
        echo "6. NTP Server" >> /home/sysmgmt/AS-IS_$HOSTNAME
        echo "-------------" >> /home/sysmgmt/AS-IS_$HOSTNAME
        cat /etc/ntp.conf | grep server | sed '/#/d' >> /home/sysmgmt/AS-IS_$HOSTNAME
        echo "" >> /home/sysmgmt/AS-IS_$HOSTNAME
        echo "7. NTP Sync Status" >> /home/sysmgmt/AS-IS_$HOSTNAME
        echo "------------------" >> /home/sysmgmt/AS-IS_$HOSTNAME
        ntpq -p >> /home/sysmgmt/AS-IS_$HOSTNAME
else
        echo "6. NTP Server" >> /home/sysmgmt/AS-IS_$HOSTNAME
        echo "-------------" >> /home/sysmgmt/AS-IS_$HOSTNAME
        echo "NTP RPM Not Installed" >> /home/sysmgmt/AS-IS_$HOSTNAME
        echo "" >> /home/sysmgmt/AS-IS_$HOSTNAME
        echo "7. NTP Sync Status" >> /home/sysmgmt/AS-IS_$HOSTNAME
        echo "------------------" >> /home/sysmgmt/AS-IS_$HOSTNAME
        echo "NTP RPM Not Installed" >> /home/sysmgmt/AS-IS_$HOSTNAME
fi

echo "" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "8. Network Information" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "----------------------" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo -e "Netstat (Port) Information"  >> /home/sysmgmt/AS-IS_$HOSTNAME
sudo netstat -antp >> /home/sysmgmt/AS-IS_$HOSTNAME
echo ""  >> /home/sysmgmt/AS-IS_$HOSTNAME
echo -e "Netstat (Route) Information" >> /home/sysmgmt/AS-IS_$HOSTNAME
sudo netstat -rn >> /home/sysmgmt/AS-IS_$HOSTNAME
echo ""  >> /home/sysmgmt/AS-IS_$HOSTNAME
echo -e "Process Informastion" >> /home/sysmgmt/AS-IS_$HOSTNAME
sudo ps -auxf >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "" >> /home/sysmgmt/AS-IS_$HOSTNAME

echo "9. DNS Information" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "---------------------" >> /home/sysmgmt/AS-IS_$HOSTNAME
cat /etc/resolv.conf | grep nameserver  | sed '/#/d' >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "" >> /home/sysmgmt/AS-IS_$HOSTNAME

echo "10. TCP Wrapper" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "---------------------" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "HOSTS.ALLOW" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "---------------------" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "$ALLOW" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "HOSTS.DENY" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "---------------------" >> /home/sysmgmt/AS-IS_$HOSTNAME
echo "$DENY" >> /home/sysmgmt/AS-IS_$HOSTNAME
