#!/bin/bash

#usage: rt-reporter.sh , response time reporter

path=`dirname $0`

. $path/conf.sh

url[0]="http://www.edoors.com/index_zh-cn.html" 
url[1]="http://news.edoors.com/gb/index.html"
url[2]="http://forum.edoors.com/"
url[3]="http://uptime.blog.edoors.com/index.php"
url[4]="http://book.edoors.com/"
url[5]="http://wayaya.world.edoors.com/"

id=0
for host in home news forum blog book world; do 
curl=${url[$id]}
let id=id+1

out=`curl -m 10 -o /dev/null -s -w "t_total: %{time_total} t_nslookup: %{time_namelookup} t_connect: %{time_connect} http_code %{http_code}\n" $curl`
exit_code=$?
t_total=`echo $out |cut -d ' ' -f 2`
t_nslookup=`echo $out |cut -d ' ' -f 4`
t_connect=`echo $out |cut -d ' ' -f 6`
http_code=`echo $out |cut -d ' ' -f 8`

#echo $t_total $t_nslookup $t_connect $http_code
data=`urlencode "$t_total:$t_nslookup:$t_connect:$http_code"`
${baseURL}\&act=update\&type=response-time\&data=$data\&dt=g\&host=$host

done
exit

exit 0


