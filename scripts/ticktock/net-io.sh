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
--vertical-label="bps" \
DEF:a="$rrdfile":incoming:AVERAGE \
DEF:b="$rrdfile":outgoing:AVERAGE \
CDEF:a8=a,8,* \
CDEF:b8=b,8,* \
AREA:a8#FF9900:"Incoming"  \
GPRINT:a8:LAST:"Current\:%8.0lf %s"  \
GPRINT:a8:AVERAGE:"Average\:%8.0lf %s"  \
GPRINT:a8:MAX:"Maximum\:%8.0lf %s\n"  \
LINE1:b8#009900:"Outgoing"  \
GPRINT:b8:LAST:"Current\:%8.0lf %s"  \
GPRINT:b8:AVERAGE:"Average\:%8.0lf %s"  \
GPRINT:b8:MAX:"Maximum\:%8.0lf %s\n" \

