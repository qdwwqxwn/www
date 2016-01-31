#!/bin/bash

group=$1
host=$2
type=$3
ts=$4

rrdpath="/var/www/data/ticktock/rra"
rrdfile="$rrdpath/$group-$host-$type.rrd"

let stime=-86400*ts
let etime=-240*ts

/usr/bin/rrdtool graph - \
--imgformat=PNG \
--start=$stime \
--end=$etime \
--title="$group $host - $type ($ts-day)" \
--rigid \
--base=1000 \
--height=120 \
--width=700 \
--alt-autoscale-max \
--lower-limit=0 \
--vertical-label="Bytes" \
DEF:a1="$rrdfile":free:AVERAGE \
DEF:b1="$rrdfile":buffers:AVERAGE \
DEF:c1="$rrdfile":cache:AVERAGE \
DEF:d1="$rrdfile":used:AVERAGE \
DEF:e1="$rrdfile":swap:AVERAGE \
CDEF:a=a1,1024,* \
CDEF:b=b1,1024,* \
CDEF:c=c1,1024,* \
CDEF:d=d1,1024,* \
CDEF:e=e1,1024,* \
AREA:a#00CF00:"Free"  \
GPRINT:a:LAST:"Current\:%8.0lf %s"  \
GPRINT:a:AVERAGE:"Average\:%8.0lf %s"  \
GPRINT:a:MAX:"Maximum\:%8.0lf %s\n"  \
STACK:b#F5F800:"Buffers"  \
GPRINT:b:LAST:"Current\:%8.0lf %s"  \
GPRINT:b:AVERAGE:"Average\:%8.0lf %s"  \
GPRINT:b:MAX:"Maximum\:%8.0lf %s\n" \
STACK:c#8D00BA:"Cache"  \
GPRINT:c:LAST:"Current\:%8.0lf %s"  \
GPRINT:c:AVERAGE:"Average\:%8.0lf %s"  \
GPRINT:c:MAX:"Maximum\:%8.0lf %s\n" \
STACK:d#FF4105:"Used"  \
GPRINT:d:LAST:"Current\:%8.0lf %s"  \
GPRINT:d:AVERAGE:"Average\:%8.0lf %s"  \
GPRINT:d:MAX:"Maximum\:%8.0lf %s\n" \
STACK:e#0000FF:"Swap"  \
GPRINT:e:LAST:"Current\:%8.0lf %s"  \
GPRINT:e:AVERAGE:"Average\:%8.0lf %s"  \
GPRINT:e:MAX:"Maximum\:%8.0lf %s" 

