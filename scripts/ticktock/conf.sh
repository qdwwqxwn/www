urlencode() {
    echo "$1" | sed -e 's/ /+/g' -e 's/&/%26/g' -e 's/\//%2F/g' -e 's/:/%3A/g'
}

ifs="    lo   eth0   eth1 "
parts="sda6 sda1 sda9 sda2 sda7 sda5 sda3 sdb1 sdc1 "
baseURL="/usr/bin/wget -o /dev/null -O /dev/null http://mnt.edoors.info/receiver.php?host=set1&group=Monitor&pwd=9a928a797245250629a70034f3627911"
