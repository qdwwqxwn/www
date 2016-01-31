<?php
/*
oneway's TickTock 
* /



	/* if we are a guest user in a non-guest area, wipe credentials */
    session_start(); 
	if (empty($_SESSION["t_user"])) {
            echo "Access Denied:" . $_SESSION["t_user"]; 
            exit; 
        } 

        $user = $_SESSION["t_user"]; 

?>
