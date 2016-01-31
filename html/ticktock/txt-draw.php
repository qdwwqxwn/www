<?php
/*
oneway's TickTock 
txt-draw.php: to display info as a table for data not suitable for graph, 
such as current disk usage. 
*/

include("./include/tauth.php");

$spath="/var/www/scripts/ticktock"; 
$rrapath="/var/www/data/ticktock/rra"; 

// Get all user, hosts, category info. May put in MySQL  in future
// current hack: rrd file format: user-host-cpu-usage.rrd.
// assuming "host" can have '-'s in it. 

// disk partitons for most hosts 
$parts = array ("/", "/boot", "/home",  "/usr", "/var", "/var/log", "/data1",
   "/data2", "/data3"); 

$files = scandir ($rrapath);

foreach ($files as $file) {
  if ( ereg (".rrd$", $file) ) {
    $tmp = ereg_replace(".rrd$", "", $file);
    $atmp = explode("-", $tmp);
    $auser = $atmp[0]; 
    $ne = count ($atmp); 
    $t1 = $atmp[$ne-2]; 
    $t2 = $atmp[$ne-1]; 
    $ahost = $atmp[1]; 
    for ($nid = 2; $nid < $ne-2; $nid ++ ) {
     $ahost = $ahost . "-" . $atmp[$nid]; 
    }
    $ausers[$auser] = 1;
    $ahosts["$auser-$t1-$t2"] = $ahosts["$auser-$t1-$t2"] . "$ahost ";
    $acats["$auser-$ahost"] = $acats["$auser-$ahost"] . "$t1-$t2 ";
  }
}

$i=1;
foreach ($ausers as $auser => $num) {
  $users[$i++] = $auser;
}


$hosts = array("SE1", "SE2"); 

$cats = array ("disk-usage");  // deleted "disk-usage"
$tscales = array(1, 2, 7, 30, 365); 

#default: display first host, all cats, at ts=1
$cuser = $user;   // current userid from session store 
$oby = $_GET["by"];
$ohost = $_GET["ht"];
$ocat = $_GET["cat"];
$cts = $_GET["ts"];
if ( $cuser === "admin" ) $cuser = $_GET["user"];
if ( empty( $cuser ) )  $cuser = $users[1];   

$hosts = explode(" ", $ahosts["$cuser-disk-usage"]); 

if ( empty( $cby ) )  $cby = "host"; 
if ( empty( $chost ) ) $chost = $hosts[0]; 

$cats = explode(" ", $acats["$cuser-$chost"]); 
if ( empty( $ccat ) ) $ccat = $cats[0]; 
if ( empty( $cts ) ) $cts = 1; 

?>
<html>
<head>
	<title>Login to TickTock</title>
	<STYLE TYPE="text/css">
	<!--
		BODY, TABLE, TR, TD {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px;}
		A {text-decoration: none;}
		A:active { text-decoration: none;}
		A:hover {text-decoration: underline; color: #333333;}
		A:visited {color: Blue;}
	-->
	</style>
</head>
<body bgcolor="#FFFFFF">
 <table width=800><tr><td width=200> &nbsp; </td> <td align="right"> 
   <a href="logout.php">Logout</a></td></tr></table>

<?php 
 if ($user === "admin" ) {
  echo "<table bgcolor=\"#FF9900\" width=800><tr><td align=\"center\" width=200> By User </td> <td> "; 
  foreach ($users as $tuser) { 
   if ( $cuser === $tuser ) {
     echo "$tuser | "; 
   } else {
     echo "<a href=\"txt-draw.php?by=$oby&ts=$cts&user=$tuser\"> $tuser | </a>"; 
   }
  }
  echo " </td> </tr> </table> ";
 } 

  echo "<table bgcolor=\"#FFCC00\" width=800><tr><td align=\"center\" width=200>
 By Category </td> <td> ";
  echo "<a href=\"draw.php?by=$oby&cat=$ocat&ht=$ohost&ts=$cts&user=$cuser\">Performance </a>";
  echo " | Disk Usage "; 
 if ($cuser === "WEBAPP" ) {
   echo "| <a href=\"rt-draw.php?by=$cby&cat=$ccat&ht=$chost&ts=$cts&user=$cuser
\">Service Response Time</a>";
 }
  echo " </td> </tr> </table> ";

?>

<!--  no time-scale for current disk usage
      <table bgcolor="#dddddd" width=800><tr><td align="center" width=200> By Timescale </td>
      <td> 
<?php
  echo "<a href=\"txt-draw.php?by=$oby&cat=$ccat&ht=$ohost&ts=1&user=$cuser\"> 1 Day |</a>"; 
  echo "<a href=\"txt-draw.php?by=$oby&cat=$ccat&ht=$ohost&ts=2&user=$cuser\"> 2 Day |</a>"; 
  echo "<a href=\"txt-draw.php?by=$oby&cat=$ccat&ht=$ohost&ts=7&user=$cuser\"> 1 Week |</a>"; 
  echo "<a href=\"txt-draw.php?by=$oby&cat=$ccat&ht=$ohost&ts=30&user=$cuser\"> 1 Month |</a>"; 
  echo "<a href=\"txt-draw.php?by=$oby&cat=$ccat&ht=$ohost&ts=365&user=$cuser\"> 1 Year </a>"; 
?>

 </td></tr> 
      </table>
-->
<br><br>

<table cellpadding=12>
<?php 
 echo "<tr><td> Host </td>"; 
 foreach ($parts as $part ) {
  echo "<td> $part </td>"; 
 }
 echo "</tr>"; 
 foreach ($hosts as $host) { 
  if (! empty($host) ) {
   unset($du); 
   $output =  exec ("$spath/disk-usage-txt.sh '$cuser' '$host' 'disk-usage' '$cts'");
   #output: /: 5, /boot: 16, /usr: 20, /var: 6, /data1: 11, /data2: 1, /home: 6,
   $myparts = explode (",", $output); 
   foreach ( $myparts as $mypart ) { 
     list($mp, $mu) = explode (':', $mypart); 
     $du[trim($mp)] = $mu; 
   }
   echo "<tr><td> $host </td>"; 
   foreach ($parts as $part ) {
    $used=$du[$part]; 
    if (!empty ($used) ) {

      # display color scheme for disk space thresholds
      if ($used > 90 ) { 
        echo "<td> <font color='#FF0000'> $used </font> </td>"; 
      } else if ($used > 80 ) {
        echo "<td> <font color='#FF9900'> $used </font> </td>"; 
      } else {
        echo "<td>  $used  </td>"; 
      }
          
    } else {
      echo "<td> n/a </td>"; 
    }
   } // e foreach
   echo "</tr>"; 
 
  }
 } 

?>

<tr height=40> <td colspan="5"> &nbsp; </td> </tr>

</table>


</body></html>
