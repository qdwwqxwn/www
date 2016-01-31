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
--vertical-label="Number" \
--units-exponent=0 \
DEF:a="$rrdfile":sleeping:AVERAGE \
DEF:b="$rrdfile":stopped:AVERAGE \
DEF:c="$rrdfile":zombie:AVERAGE \
DEF:d="$rrdfile":running:AVERAGE \
AREA:a#0000FF:"sleeping"  \
GPRINT:a:LAST:"Current\:%8.0lf "  \
GPRINT:a:AVERAGE:"Average\:%8.0lf "  \
GPRINT:a:MAX:"Maximum\:%8.0lf \n"  \
STACK:b#00DD00:"stopped"  \
GPRINT:b:LAST:"Current\:%8.0lf "  \
GPRINT:b:AVERAGE:"Average\:%8.0lf "  \
GPRINT:b:MAX:"Maximum\:%8.0lf \n" \
STACK:c#FFFF00:"zombie"  \
GPRINT:c:LAST:"Current\:%8.0lf "  \
GPRINT:c:AVERAGE:"Average\:%8.0lf "  \
GPRINT:c:MAX:"Maximum\:%8.0lf \n" \
STACK:d#FF2200:"running"  \
GPRINT:d:LAST:"Current\:%8.0lf "  \
GPRINT:d:AVERAGE:"Average\:%8.0lf "  \
GPRINT:d:MAX:"Maximum\:%8.0lf \n" \

