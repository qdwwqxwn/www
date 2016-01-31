#! /usr/bin/bash
# Stuff daily data as hourly 

history=0   # if 1, fill in some historical data, assuming 1/1/2005-11/30/2015 
            # otherwise bring data up to date, starting from is 12/1/2015 

rrdpath=/var/www/data

cus="Gap"

itype="Stock_Prices" 
rrdf=$rrdpath/${cus}/${itype}.rrd
stime=`date -d "10/1/2015" +%s`
dt=3600

if [ $history -gt 0 ]; then 
  echo history ...
  etime=`date -d "12/11/2015" +%s`
  let len=(etime-stime)/dt

  ts=$stime
  head -$len  /var/www/scripts/Gap-demo/raw-data/Stock_Prices.txt | while read line
  do 
   price=`echo $line |awk '{print $2}'`
   #echo "$ts:$price" 
   /usr/bin/rrdtool update $rrdf "$ts:$price" 
   let ts=ts+dt
  done

else 
  echo updating ...
  cdate=`date +"%m/%d/%Y %H:00:00"`
  ctime=`date -d "$cdate" +%s`
  let len=(ctime-stime)/dt

  price=`head -$len /var/www/scripts/Gap-demo/raw-data/Stock_Prices.txt |tail -1 |awk '{print $2}'`
  /usr/bin/rrdtool update $rrdf "$ctime:$price" 
fi
  
  

