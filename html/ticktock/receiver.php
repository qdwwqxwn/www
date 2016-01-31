<?php

include("./include/passwds.php");
/*
 Edoors.com
*/

function construct_ds($data, $type) {
   	$dses = explode(" ", $data); 
      	$dsf=""; 
  	foreach ($dses as $ds) {
         if ($ds) { 
           $ds=escapeshellarg($ds);
           $dsf = $dsf . "DS:$ds:$type \\\n"; 
         }
        }
        return $dsf;
}
  
#http://mnt.edoors.info/receiver.php?host=set1&group=Monitor&pwd=a

/* set default action */
if (!isset($_REQUEST["act"])) { $_REQUEST["act"] = ""; }

// data type: gauge or counter ?
switch ($_GET["dt"]) { 
   case 'c':  
    $dt = 'COUNTER:480:0:U'; 
    break;
   case 'g':  
    $dt = 'GAUGE:480:0:U'; 
    break;
   default: 
    echo "access-denied";   // do not change the msg
    exit;
}

$rrdpath='/var/www/data/ticktock/rra'; 
$rrdcreate='/usr/bin/rrdtool create'; 
$rrdupdate='/usr/bin/rrdtool update'; 
$step="--step 240 \\\n";   // 4 minutes time step 
$rras=<<<EOS
RRA:AVERAGE:0.5:1:1200 \
RRA:AVERAGE:0.5:5:1400 \
RRA:AVERAGE:0.5:30:1550 \
RRA:AVERAGE:0.5:360:1600 \
RRA:MAX:0.5:1:1200 \
RRA:MAX:0.5:5:1400 \
RRA:MAX:0.5:30:1550 \
RRA:MAX:0.5:360:1600 
EOS;

// rrd file name eg. webapp-db1-cpu-usage.rrd
$user_host=$_GET["group"] . '-' . $_GET["host"]; 
$rraf1=$rrdpath . '/' . $user_host; 

list($t1, $tmp) = explode("-", $_GET["type"]); 
$upswd = $pswd[ $_GET["group"] ]; 

if ($_REQUEST["act"] == "create" ) {
   if ( !isset($upswd) || $upswd !== $_GET["pwd"] ) {
     echo "access-denied";   // do not change the msg
     exit; 
   }

     switch ($t1) { 
     case 'cpu': 
     case 'mem':
     case 'proc':
     case 'disk':
     case 'net':
     case 'sock':
        $dsf = construct_ds($_GET["data"], $dt);
        break;
     default: 
        $dsf =""; 
     } // e switch
  
  // do create
     if ($dsf) { 
        $rraf=$rraf1 . '-' . $_GET["type"] . '.rrd'; 
        if ( !is_file($rraf)  )    //do not overwrite existing rra file
        system("$rrdcreate $rraf $step $dsf $rras"); 
        // auth: credentials for update operations:  md5(pswd + IP addr)
        // won't work for dynamic IPs, so diable it. Use naive version.
       //$newkey=md5($upswd . $_SERVER['REMOTE_ADDR']); 
       $newkey=md5($upswd);
       echo $newkey; 
     }

} 

if ($_REQUEST["act"] == "update" ) {
     // authentication
     if ( !isset($upswd) || 
        //md5($upswd . $_SERVER['REMOTE_ADDR']) !== $_GET["pwd"] ) {
        md5($upswd) !== $_GET["pwd"] ) {
       echo "access-denied";   // do not change the msg
       exit; 
     }
     
     list($t1, $tmp) = explode("-", $_GET["type"]); 
     switch ($t1) {
     case 'cpu':
     case 'mem':
     case 'proc':
     case 'disk':
     case 'net':
     case 'sock':
        $dsf = "N:" . escapeshellarg($_GET["data"]);
        break;
     default: 
        $dsf = ""; 
     } // e switch

  // do update 
     if ($dsf) {
        $rraf=$rraf1 . '-' . $_GET["type"] . '.rrd';
        system("$rrdupdate $rraf $dsf");
     }

}

?>
