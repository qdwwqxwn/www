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
--vertical-label="Percent" \
--units-exponent=0 \
DEF:a="$rrdfile":user:AVERAGE \
DEF:b="$rrdfile":system:AVERAGE \
DEF:c="$rrdfile":idle:AVERAGE \
DEF:d="$rrdfile":iowait:AVERAGE \
AREA:a#3399FF:"user"  \
GPRINT:a:LAST:"Current\:%8.0lf "  \
GPRINT:a:AVERAGE:"Average\:%8.0lf "  \
GPRINT:a:MAX:"Maximum\:%8.0lf \n"  \
STACK:b#FF9900:"system"  \
GPRINT:b:LAST:"Current\:%8.0lf "  \
GPRINT:b:AVERAGE:"Average\:%8.0lf "  \
GPRINT:b:MAX:"Maximum\:%8.0lf \n" \
STACK:c#00DD00:"idle"  \
GPRINT:c:LAST:"Current\:%8.0lf "  \
GPRINT:c:AVERAGE:"Average\:%8.0lf "  \
GPRINT:c:MAX:"Maximum\:%8.0lf \n" \
STACK:d#FF2200:"iowait"  \
GPRINT:d:LAST:"Current\:%8.0lf "  \
GPRINT:d:AVERAGE:"Average\:%8.0lf "  \
GPRINT:d:MAX:"Maximum\:%8.0lf \n" \

