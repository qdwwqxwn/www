#! /usr/bin/bash

# Create daily rrd 

rrdpath=/var/www/data

cus="Gap"
type="Stock_Prices US_Sales China_Sales EU_Sales Marketing_Expenses Media_Exposure Social_Trend Web_Sales Web_Traffic Total_Inventory" 

mkdir -p $rrdpath/$cus 

for itype in $type; do 

  rrdf=$rrdpath/$cus/${itype}.rrd

 /usr/bin/rrdtool create $rrdf \
   --step 3600 --start 315550800 \
   DS:$itype:GAUGE:172800:0:U \
   RRA:AVERAGE:0.5:1:3650 \
   RRA:AVERAGE:0.5:7:2000 \
   RRA:AVERAGE:0.5:30:500 \
   RRA:AVERAGE:0.5:365:20 \
   RRA:MAX:0.5:7:2000 \
   RRA:MAX:0.5:30:500 \
   RRA:MAX:0.5:365:20 \
   RRA:LAST:0.5:1:3650 

done

# date -d "1980/1/1" +%s
# 315550800

