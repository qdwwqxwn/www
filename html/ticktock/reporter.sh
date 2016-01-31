#!/bin/bash

#usage: reporter.sh 

path=`dirname $0`

. $path/conf.sh

ver=`uname -r |awk -F'.' '{OFS=""; print \$1, \$2}'`

# CPU usage (user, system, idle, and iowat) and load avg (1, 5 and 15min)
# assuming kernel 2.6.x 
output=`uptime`
load=`echo $output | grep 'load average' | awk -F 'load average:' '{print \$2}' |sed -e 's/,/:/g' -e 's/ //g'`
usage=`top -b -n 1 |head -n 3 |tail -n 1 |awk '{OFS=":";print \$2, \$3, \$5, \$6}' |sed -e 's/%..,//g'`

ltmp=`urlencode "$load"`
utmp=`urlencode "$usage"`

${baseURL}\&act=update\&type=cpu-usage\&data=$utmp\&dt=g
${baseURL}\&act=update\&type=cpu-load\&data=$ltmp\&dt=g

# mem usage: free,  buffers, cache, used (stacked) and swap (line)
#free:buffer:cache
fbc=`free |grep 'Mem:' |awk '{OFS=":"; print \$4, \$6, \$7}'`
used=`free |grep 'buffers/cache' |awk '{print \$3}'`
swap=`free |grep '^Swap' |awk '{print \$3}'`
data=`urlencode "$fbc:$used:$swap"`

${baseURL}\&act=update\&type=mem-usage\&data=$data\&dt=g

#processes (sleeping, stoped, zombi, running) (stacked)
if [ $ver -eq 24 ]; then
 out=`top -b -n 1 |head -n 6 |grep processes |awk '{OFS=":"; print \$3, \$9, \$7, \$5}'`
else
 out=`top -b -n 1 |head -n 3 |grep 'Tasks' |awk '{OFS=":"; print \$6, \$8, \$10, \$4}'`
fi
data=`urlencode "$out"`

${baseURL}\&act=update\&type=proc-usage\&data=$data\&dt=g

# disk read & write and usage -- send mount points to server
used=''
for part in $parts; do
 duse=`df -P |grep "/dev/$part" |awk '{print \$5}' |sed -e 's/%//'`
 used="$used:$duse"
done

read=''
write=''
devs=`/usr/bin/iostat -d |tail -n +4  |awk '{ORS=" "; print \$1}'`
for dev in $devs; do 
 if [ $ver -eq 24 ]; then 
  sread=`grep " $part " /proc/partitions |awk '{print \$7}'`
  swrite=`grep " $part " /proc/partitions |awk '{print \$11}'`
 else 
  sread=`/usr/bin/iostat -d |grep "$dev "|awk '{print \$5}'`
  swrite=`/usr/bin/iostat -d |grep "$dev "|awk '{print \$6}'`
 fi
 read="$read:$sread"
 write="$write:$swrite"
done
 rdata=`echo $read |sed -e 's/^://'`
 wdata=`echo $write |sed -e 's/^://'`
 udata=`echo $used |sed -e 's/^://'`
 
rurl=`urlencode "$rdata"`
wurl=`urlencode "$wdata"`
uurl=`urlencode "$udata"`

${baseURL}\&act=update\&type=disk-read\&data=$rurl\&dt=c
${baseURL}\&act=update\&type=disk-write\&data=$wurl\&dt=c
${baseURL}\&act=update\&type=disk-usage\&data=$uurl\&dt=g

# network IO:  a separate inf for each rrd : incoming:outgoing 
for dev in $ifs; do
 io=`grep " ${dev}:" /proc/net/dev |awk -F ':' '{print \$2}' |awk '{OFS=":"; print \$1, \$9}'`
 data=`urlencode "$io"`
 ${baseURL}\&act=update\&type=net-$dev\&data=$data\&dt=c
done

# tcp socket usage and open files (est, syn_sent, last_ack) 
output=`netstat -tan|tail -n +3|awk '{print \$6}'`
est=0
syn_sent=0
last_ack=0

for state in $output; do
    case "$state" in
        ESTABLISHED)
         let est=est+1
         ;;
        SYN_SENT)
         let syn_sent=syn_sent+1
         ;;
        LAST_ACK)
         let last_ack=last_ack+1
         ;;
    esac
done

data=`urlencode "$est:$syn_sent:$last_ack"`

${baseURL}\&act=update\&type=sock-usage\&data=$data\&dt=g

exit 0


