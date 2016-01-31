<?php
/*

oneway's TickTock

*/

session_start();

unset($_SESSION["t_user"]);
header("Location: index.php");
exit;

?>
