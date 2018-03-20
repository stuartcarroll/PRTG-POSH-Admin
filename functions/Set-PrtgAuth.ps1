function Set-PrtgAuth
{	
 	 Param(
 	 	[Parameter(Mandatory=$true)]
		[string]$PRTGHost,
		[string]$User,
		[string]$Passhash
		)
		set-variable -name PRTGHost -value $PRTGHost -scope Global
		$auth = "username="+$User+"&passhash="+$Passhash
		set-variable -name auth -value $auth -scope Global
}