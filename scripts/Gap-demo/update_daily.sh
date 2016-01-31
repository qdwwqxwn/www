#! /usr/bin/bash

# Create daily rrd 
history=0   # if 1, fill in some historical data, assuming 1/1/2005-11/30/2015
            # otherwise bring data up to date, starting from is 12/1/2015

rrdpath=/var/www/data
type="US_Sales China_Sales EU_Sales Marketing_Expenses Media_Exposure Social_Trend Web_Sales Web_Traffic Total_Inventory"
stime=`date -d "10/1/2015" +%s`
dt=3600

cus="Gap"

if [ $history -gt 0 ]; then
  echo history ...

  etime=`date -d "12/13/2015" +%s`
  let len=(etime-stime)/dt

  ts=$stime
  head -$len /var/www/scripts/Gap-demo/raw-data/Stock_Prices.txt | while read line
  do
     price=`echo $line |awk '{print $2}'`
     itype="US_Sales" 
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", 1000+p*(100+2*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="China_Sales" 
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", p*(100+4*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="EU_Sales" 
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", 2000+p*(50+2*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="Marketing_Expenses" 
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", p*(50+2*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="Media_Exposure" 
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", (p-10)*(2+sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="Social_Trend" 
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", sqrt(p*10)}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="Web_Sales" 
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", 500+p*(50+4*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="Web_Traffic" 
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", 5000+p*(500+40*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="Total_Inventory" 
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", (200-p)*(10+4*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"

    let ts=ts+dt
  done

else
  echo updating ...
  cdate=`date +"%m/%d/%Y %H:00:00"`
  ctime=`date -d "$cdate" +%s`
  ts=$ctime
  let len=(ctime-stime)/dt

  price=`head -$len /var/www/scripts/Gap-demo/raw-data/Stock_Prices.txt |tail -1 |awk '{print $2}'`
  echo $price
     itype="US_Sales"
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", 1000+p*(100+2*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="China_Sales"
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", p*(100+4*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="EU_Sales"
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", 2000+p*(50+2*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="Marketing_Expenses"
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", p*(50+2*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="Media_Exposure"
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", (p-10)*(2+sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="Social_Trend"
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", sqrt(p*10)}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="Web_Sales"
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", 500+p*(50+4*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="Web_Traffic"
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", 5000+p*(500+40*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"
     itype="Total_Inventory"
      nprice=`awk -v p=$price -v id=$id -v r=$RANDOM 'BEGIN {printf "%.2f", (200-p)*(10+4*sin(r))}'`
      rrdf=$rrdpath/${cus}/${itype}.rrd
     /usr/bin/rrdtool update $rrdf "$ts:$nprice"

fi



