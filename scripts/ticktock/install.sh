#!/bin/bash

#usage: install.sh machine-name username passwd
urlencode() {
    echo "$1" | sed -e 's/ /+/g' -e 's/&/%26/g' -e 's/\//%2F/g' -e 's/:/%3A/g'
}

# Check if wget is there
wget --version > /dev/null 2>&1

if [ $? -ne 0 ]; then 
 echo "wget is needed. Please make sure it is installed and in your path."
 exit 1
fi

# Check if cron job is allowed. 
if [ ! -u /usr/bin/crontab ]; then
 echo "You do not have permissioin to run cron job. You may need"
 echo "to fix it by running \"chmod u+s /usr/bin/crontab\" as root"
 echo "and then run this installation again."
 exit 1
fi


# Check OS version. Currently only supports 2.6.x and 2.4.x
ver=`uname -r |awk -F'.' '{OFS=""; print \$1, \$2}'`
if [ $ver -ne 26 -a $ver -ne 24 ]; then
 echo "Sorry, current version only supports Linux kernel 2.6.x" 
 echo "Installation cancelled" 
 exit 1
fi 

if [ $# -ne 3 ]; then
 echo "Usage: `basename $0`  machine-name username passwd"
 echo "Example: `basename $0` web4 webapp webpswd"
 exit 1
fi

pswd=`echo -n $3 |md5sum |cut -d ' ' -f 1`

baseURL="/usr/bin/wget -o /dev/null -O - http://mnt.edoors.info/receiver.php?host=$1&group=$2&pwd=$pswd"

PWD=`pwd`
conf="$PWD/conf.sh"

cat > $conf <<EOF 
urlencode() {
    echo "\$1" | sed -e 's/ /+/g' -e 's/&/%26/g' -e 's/\//%2F/g' -e 's/:/%3A/g'
}

EOF


# save local configuration
# network interfaces
ifs=`tail -n +3 /proc/net/dev |awk -F':' '{ORS=" ";print \$1}'`
echo "ifs=\"$ifs\"" >> $conf

# disk partitions and mounts
parts=`df -x tmpfs -x nfs |tail -n +2 |awk '{ORS=" "; print \$1}' |sed -e 's/\/dev\///g'`
echo "parts=\"$parts\"" >> $conf
mnts=`df -x tmpfs -x nfs |tail -n +2 |awk '{ORS=" "; print \$6}'`

# create rrd files on server 
# CPU usage (user, system, idle, iowait ) and load avg (1, 5 and 15min) 
url=`urlencode "user system idle iowait"`
newkey=`${baseURL}\&act=create\&type=cpu-usage\&data=$url\&dt=g`

if [ "$newkey" == "access-denied" -o $? -ne 0 ]; then
 echo "Installation 1 failed. Please contact oneway."
 exit 1
else 
 updtURL="/usr/bin/wget -o /dev/null -O /dev/null http://mnt.edoors.info/receiver.php?host=$1&group=$2&pwd=$newkey"
 echo "baseURL=\"$updtURL\"" >> $conf
fi

url=`urlencode "1min 5min 15min"`
${baseURL}\&act=create\&type=cpu-load\&data=$url\&dt=g

# mem usage: free, buffers, cache, used (stacked) and swap (line) 
url=`urlencode "free buffers cache used swap"`
${baseURL}\&act=create\&type=mem-usage\&data=$url\&dt=g

#processes (sleeping, stoped, zombi, running) (stacked) 
url=`urlencode "sleeping stopped zombie running"`
${baseURL}\&act=create\&type=proc-usage\&data=$url\&dt=g

# disk read & write and usage -- send mount points to server
# RRDTOOL DS names can not have '/', so replace with '_'
tmp=`echo $mnts | sed -e 's/\//_/g'`
url=`urlencode "$tmp"`
${baseURL}\&act=create\&type=disk-read\&data=$url\&dt=c
${baseURL}\&act=create\&type=disk-write\&data=$url\&dt=c
${baseURL}\&act=create\&type=disk-usage\&data=$url\&dt=g

# network IO:  a separate inf for each rrd
url=`urlencode "incoming outgoing"`
for dev in $ifs; do 
 ${baseURL}\&act=create\&type=net-$dev\&data=$url\&dt=c
done

# tcp socket usage (est, syn_sent, last_ack) 
url=`urlencode "estab syn_sent last_ack"`
${baseURL}\&act=create\&type=sock-usage\&data=$url\&dt=g

# do cron only first time installation 
if [ ! -f crontab ]; then
# generate crontab file 
 /usr/bin/crontab -l > crontab 2> /dev/null
 echo "*/4 * * * * $PWD/reporter.sh" >> crontab

#submit to cron
 /usr/bin/crontab -r > /dev/null 2>&1 
 /usr/bin/crontab crontab 
fi 

/usr/bin/wget -o /dev/null -O reporter.sh http://mnt.edoors.info/reporter.sh 

if [ $? -ne 0 ]; then 
 echo "Installation 2 failed. Please contact oneway."
 exit 1
fi

chmod u+x reporter.sh

echo Installation completed. 

