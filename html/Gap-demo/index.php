<?php
/*
oneway's sysmon package
*/

session_start();

include("./include/passwds.php");

/* set default action */
if (!isset($_REQUEST["action"])) { $_REQUEST["action"] = ""; }

switch ($_REQUEST["action"]) {
case 'login':
 
       $user = $_POST["login_username"]; 
       $upwd = $_POST["login_password"]; 
         
       if ( strlen( $user )  && md5($upwd) === $pswd[$user] ) { //auth'd 

		/* set the php session */
		$_SESSION["t_user"] = $user;

		header("Location: draw.php");

	} 
}

?>
<html>
<head>
	<title>Data Portal Login</title>
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

<body bgcolor="#FFFFFF" onload="document.login.login_username.focus()">

<!-- apparently IIS 5/4 have a bug (Q176113) where setting a cookie and calling the header via
'Location' does not work. This seems to fix the bug for me at least... -->
<form name="login" method="post" action="<?php print basename($_SERVER["PHP_SELF"]);?>">

<table align="center">
	<tr height=100>
		<td colspan="2" bgcolor="#dddddd" align="center"> Welcome to Your Data Portal </td>
	</tr>
	<?php
	if ($_REQUEST["action"] == "login") {?>
	<tr height="10"><td></td></tr>
	<tr>
		<td colspan="2"><font color="#FF0000"><strong>Invalid User Name/Password Please Retype:</strong></font></td>
	</tr>
	<?php }?>
	<tr height="10"><td></td></tr>
	<tr>
		<td colspan="2">Please enter your user name and password below:</td>
	</tr>
	<tr height="10"><td></td></tr>
	<tr>
		<td>User Name:</td>
		<td><input type="text" name="login_username" size="40" style="width: 295px;"></td>
	</tr>
	<tr>
		<td>Password:</td>
		<td><input type="password" name="login_password" size="40" style="width: 295px;"></td>
	</tr>
	<tr height="10"><td></td></tr>
	<tr> 
		<td colspan=2 align="center"><input type="submit" value="Login"></td>
	</tr>
</table>

<input type="hidden" name="action" value="login">

</form>

</body>
</html>
