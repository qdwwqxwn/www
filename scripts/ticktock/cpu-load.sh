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
--vertical-label="No unit" \
--units-exponent=0 \
DEF:a="$rrdfile":1min:AVERAGE \
DEF:b="$rrdfile":5min:AVERAGE \
DEF:c="$rrdfile":15min:AVERAGE \
AREA:a#FF6600:"1min"  \
GPRINT:a:LAST:"Current\:%8.2lf "  \
GPRINT:a:AVERAGE:"Average\:%8.2lf "  \
GPRINT:a:MAX:"Maximum\:%8.2lf \n"  \
AREA:b#FF9900:"5min"  \
GPRINT:b:LAST:"Current\:%8.2lf "  \
GPRINT:b:AVERAGE:"Average\:%8.2lf "  \
GPRINT:b:MAX:"Maximum\:%8.2lf \n" \
AREA:c#FFCC00:"15min"  \
GPRINT:c:LAST:"Current\:%8.2lf "  \
GPRINT:c:AVERAGE:"Average\:%8.2lf "  \
GPRINT:c:MAX:"Maximum\:%8.2lf \n" \

