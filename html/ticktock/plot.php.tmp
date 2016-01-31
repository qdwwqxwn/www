<?php

//plot.php?ht=$host&cat=$ccat&ts=$cts&user=$cuser

include("./include/tauth.php");
$spath="/var/www/scripts/ticktock"; 

$ccat = $_GET["cat"]; 
$cuser = $_GET["user"]; 
$cht = $_GET["ht"]; 
$cts = $_GET["ts"]; 

switch ( $ccat ) { 
  case 'cpu-load': 
  case 'cpu-usage': 
  case 'mem-usage': 
  case 'disk-read': 
  case 'disk-write':
  case 'proc-usage': 
  case 'sock-usage':
  case 'response-time':
   passthru("$spath/$ccat.sh '$cuser' '$cht' '$ccat' '$cts'"); 
   break; 
  case 'net-lo':
  case 'net-eth0':
  case 'net-eth1':
  case 'net-eth2':
  case 'net-eth3':
  case 'net-tun0':
  case 'net-tun1':
  case 'net-tun2':
  case 'net-tunl0':
  case 'net-tunl1':
  case 'net-tunl2':
   passthru("$spath/net-io.sh '$cuser' '$cht' '$ccat' '$cts'"); 
   break;
}

?> 

