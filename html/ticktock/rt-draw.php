<?php
/*
oneway's TickTock 
*/

include("./include/tauth.php");

$spath="/var/www/scripts/ticktock"; 
$rrapath="/var/www/data/ticktock/rt-rra"; 

// Get all user, hosts, category info. May put in MySQL  in future
// current hack: rrd file format: user-host-cpu-usage.rrd.
// assuming "host" can have '-'s in it. 

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

$cats = array ("cpu-load", "cpu-usage", "mem-usage", "disk-read",
               "disk-write", "proc-usage", "sock-usage", 
               "net-eth0", "net-eth1", "net-lo");  // deleted "disk-usage"
$tscales = array(1, 2, 7, 30, 365); 

#default: display first host, all cats, at ts=1
$cuser = $user;   // current userid from session store 
$oby = $_GET["by"];
$ohost = $_GET["ht"];
$ocat = $_GET["cat"];
$cts = $_GET["ts"];
if ( $cuser === "admin" ) $cuser = $_GET["user"];
if ( empty( $cuser ) )  $cuser = $users[1];   

$hosts = explode(" ", $ahosts["$cuser-response-time"]); 

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
     echo "<a href=\"rt-draw.php?by=$oby&ts=$cts&user=$tuser\"> $tuser | </a>"; 
   }
  }
  echo " </td> </tr> </table> ";
 } 

  echo "<table bgcolor=\"#FFCC00\" width=800><tr><td align=\"center\" width=200>
 By Category </td> <td> ";
  echo "<a href=\"draw.php?by=$oby&cat=$ocat&ht=$ohost&ts=$cts&user=$cuser\">Performance </a>";
  echo " | <a href=\"txt-draw.php?by=$oby&cat=$ccat&ht=$host&ts=$cts&user=$cuser\">Disk Usage</a> ";
   echo "| Service Response Time";
  echo " </td> </tr> </table> ";

?>

      <table bgcolor="#dddddd" width=800><tr><td align="center" width=200> By Timescale </td>
      <td> 
<?php
  echo "<a href=\"rt-draw.php?by=$oby&cat=$ccat&ht=$ohost&ts=1&user=$cuser\"> 1 Day |</a>"; 
  echo "<a href=\"rt-draw.php?by=$oby&cat=$ccat&ht=$ohost&ts=2&user=$cuser\"> 2 Day |</a>"; 
  echo "<a href=\"rt-draw.php?by=$oby&cat=$ccat&ht=$ohost&ts=7&user=$cuser\"> 1 Week |</a>"; 
  echo "<a href=\"rt-draw.php?by=$oby&cat=$ccat&ht=$ohost&ts=30&user=$cuser\"> 1 Month |</a>"; 
  echo "<a href=\"rt-draw.php?by=$oby&cat=$ccat&ht=$ohost&ts=365&user=$cuser\"> 1 Year </a>"; 
?>

 </td></tr> 
      </table>

<table>
<?php 
 foreach ($hosts as $host) { 
  if (! empty($host) )
  echo "<tr> <td colspan=5><img src=\"plot.php?ht=$host&cat=$ccat&ts=$cts&user=$cuser\"></td> </tr>"; 
 } 

?>

<tr height=40> <td colspan="5"> &nbsp; </td> </tr>

</table>


</body></html>
