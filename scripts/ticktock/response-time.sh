#!/bin/bash

group=$1
host=$2
type=$3
ts=$4

rrdpath="/var/www/data/ticktock/rt-rra"
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
--vertical-label="second" \
--units-exponent=0 \
DEF:a="$rrdfile":t_total:AVERAGE \
DEF:b="$rrdfile":t_lookup:AVERAGE \
DEF:c="$rrdfile":t_connect:AVERAGE \
DEF:d="$rrdfile":http_code:AVERAGE \
GPRINT:d:LAST:"Current HTTP Code\:%8.0lf\n"  \
AREA:a#FF9900:"Total"  \
GPRINT:a:LAST:"Current\:%8.2lf "  \
GPRINT:a:AVERAGE:"Average\:%8.2lf "  \
GPRINT:a:MAX:"Maximum\:%8.2lf \n"  \
LINE1:b#009900:"DNS lookup"  \
GPRINT:b:LAST:"Current\:%8.2lf "  \
GPRINT:b:AVERAGE:"Average\:%8.2lf "  \
GPRINT:b:MAX:"Maximum\:%8.2lf \n" \
LINE1:c#990000:"Connect"  \
GPRINT:c:LAST:"Current\:%8.2lf "  \
GPRINT:c:AVERAGE:"Average\:%8.2lf "  \

