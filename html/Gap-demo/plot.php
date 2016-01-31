<?php

//plot.php?ht=$host&cat=$ccat&ts=$cts&user=$cuser

include("./include/tauth.php");
$spath="/var/www/scripts/Gap-demo/"; 

$type = $_GET["cat"]; 
//$cuser = $_GET["user"]; 
//$cht = $_GET["ht"]; 
$cts = $_GET["ts"]; 

passthru("$spath/plot-$type.sh '$cts'"); 

?> 

