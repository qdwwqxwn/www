#! /usr/bin/bash

#cus=$1  # customer name
#type=$2
ts=$1     # time scale 

let xlen=5*ts
let xdis=2*ts
let xmin=1*ts

cus="Gap"
#type="Stock_Prices US_Sales China_Sales EU_Sales Marketing_Expenses Media_Exposure Social_Trend Web_Sales Web_Traffic"
#for itype in $type; do
# echo "DEF:$itype=/var/www/data/$cus/${itype}.rrd:$itype:AVERAGE \\"
#done

let stime=-86400*30*ts

/usr/bin/rrdtool graph - \
--imgformat=PNG \
--start=$stime \
--title="Media Exposure and Social Trend (last $ts months)" \
--rigid \
--base=1000 \
--height=240 \
--width=500 \
--alt-autoscale-max \
--lower-limit=0 \
--vertical-label="Exposure and Trend" \
--units-exponent=0 \
--x-grid DAY:$xdis:DAY:$xmin:DAY:$xlen:0:%b%d \
-Y \
--font DEFAULT:9:Times \
--font TITLE:12:Times \
--font UNIT:10:Times \
--color SHADEA#AAAAAA \
--color SHADEB#AAAAAA \
--color CANVAS#FFFFFF \
--color BACK#AAAAAA \
DEF:Stock_Prices=/var/www/data/Gap/Stock_Prices.rrd:Stock_Prices:AVERAGE \
DEF:US_Sales=/var/www/data/Gap/US_Sales.rrd:US_Sales:AVERAGE \
DEF:China_Sales=/var/www/data/Gap/China_Sales.rrd:China_Sales:AVERAGE \
DEF:EU_Sales=/var/www/data/Gap/EU_Sales.rrd:EU_Sales:AVERAGE \
DEF:Marketing_Expenses=/var/www/data/Gap/Marketing_Expenses.rrd:Marketing_Expenses:AVERAGE \
DEF:Media_Exposure=/var/www/data/Gap/Media_Exposure.rrd:Media_Exposure:AVERAGE \
DEF:Social_Trend=/var/www/data/Gap/Social_Trend.rrd:Social_Trend:AVERAGE \
DEF:Web_Sales=/var/www/data/Gap/Web_Sales.rrd:Web_Sales:AVERAGE \
DEF:Web_Traffic=/var/www/data/Gap/Web_Traffic.rrd:Web_Traffic:AVERAGE \
LINE3:Media_Exposure#3399FF:"Media Exposure" \
LINE3:Social_Trend#005500:"Social Trend" 

