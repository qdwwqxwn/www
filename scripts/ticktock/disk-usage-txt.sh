#!/bin/bash

group=$1
host=$2
type=$3
ts=$4

rrdpath="/var/www/data/ticktock/rra"
rrdfile="$rrdpath/$group-$host-$type.rrd"

colors=(FF0000 00FF00 0000FF FF9900 00FFFF DD0000 00DD00 444444 DD00DD 00DDDD 003366 999900 FF33FF)
# get partitions 
parts=`/usr/bin/rrdtool info $rrdfile |grep "^ds" |awk -F'.' '{print \$1}' |awk 'seen[\$0]++ == 1' |sed -e 's/ds\[//g' -e 's/\]//g'`

def=""
cdef=""
lgd=""
id=0
for part in $parts; do 
  color=${colors[$id]}
  let id=id+1
  spart=`echo $part |sed -e 's/_/\//g'`
  def="$def DEF:$part=\"$rrdfile\":$part:AVERAGE"
  cdef="$cdef CDEF:${part}_1=$part,1,*"
  lgd="$lgd PRINT:${part}_1:LAST:\"$spart\:%8.0lf, \" "
done
  
let stime=-86400*ts
let stime=-480*ts
let etime=-240*ts

out=`bash <<EOF 
/usr/bin/rrdtool graph a.png \
 --start=$stime \
 --end=$etime \
 --lower-limit=0 --vertical-label="Percent" $def $cdef $lgd
EOF
`
echo $out | cut -d ' ' -f 2-

