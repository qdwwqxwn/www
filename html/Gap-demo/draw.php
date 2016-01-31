<?php
/*
oneway's TickTock 
*/

include("./include/tauth.php");

// Get all user, hosts, category info. May put in MySQL  in future
// current hack: rrd file format: user-host-cpu-usage.rrd.
// assuming "host" can have '-'s in it. 

$cts = $_GET["ts"];
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

<table bgcolor="#dddddd" width=1234><tr><td align="center" width=200> By Timescale </td>
 <td> 
<?php
  echo "<a href=\"draw.php?ts=1\"> 1 Month |</a>"; 
  echo "<a href=\"draw.php?ts=3\"> 3 Months |</a>"; 
  echo "<a href=\"draw.php?ts=6\"> 6 Months |</a>"; 
  echo "<a href=\"draw.php?ts=12\"> 12 Months </a>"; 
?>

 </td></tr> 
      </table>
<br>

<table>
<?php 
  echo "<tr> <td colspan=5><img src=\"plot.php?cat=Stock_Prices&ts=$cts\"></td>"; 
  echo "<td colspan=5><img src=\"plot.php?cat=Sales&ts=$cts\"></td> </tr>"; 
  echo "<tr> <td colspan=5><img src=\"plot.php?cat=Web&ts=$cts\"></td>"; 
  echo "<td colspan=5><img src=\"plot.php?cat=Media&ts=$cts\"></td> </tr>"; 
  echo "<tr> <td colspan=5><img src=\"plot.php?cat=Marketing&ts=$cts\"></td>"; 
  echo "<td colspan=5><img src=\"plot.php?cat=Marketing_Web&ts=$cts\"></td> </tr>"; 
  echo "<tr> <td colspan=5><img src=\"plot.php?cat=Inventory_Sales&ts=$cts\"></td>"; 
  echo "<td>&nbsp;</td> </tr>"; 
?>

<tr height=40> <td colspan="5"> &nbsp; </td> </tr>

</table>


</body></html>
