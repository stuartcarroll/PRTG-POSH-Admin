<#
.SYNOPSIS
Creates PRTG authetnication string for use with other PRTG functions

.DESCRIPTION
Allows user to enter the FQDN of the PRTG Server, Username and Passhash which is stores as a variable used by other PRTG functions in this module

.PARAMETER PRTGHost
The FQDN of the PRTG Server
.PARAMETER User
The username of the PRTG user this script will use for queries
.PARAMETER Password
The password of the PRTG user this script will use for queries
.PARAMETER Passhash
The PRTG user Passhash. For more details see:https://www.paessler.com/manuals/prtg/user_accounts_settings#settings

.EXAMPLE

Sets the PRTG Server and authentication data for PRTG functions:

Set-PrtgAuth -PRTGHost <PRTG Server FQDN> -User <PRTG User> -Passhash <Passhash>

Set-PrtgAuth -PRTGHost my.prtgserver.com -User user1 -Passhash 1234

.EXAMPLE

Generates the user's passhash and sets the PRTG Server and authentication data for PRTG functions:

Set-PrtgAuth -PRTGHost <PRTG Server FQDN> -User <PRTG User> -Password <Passhash>

Set-PrtgAuth -PRTGHost my.prtgserver.com -User user1 -Password MyPassw0rd1

.Notes

You need this function to set the auth variable for other PRTG functions in this module.

#>

function Set-PrtgAuth
{	
 	 Param(
 	 	[Parameter(Mandatory=$true)]
		[string]$PRTGHost,
        [Parameter(Mandatory=$true)]
		[string]$User,
		[string]$Passhash,
		[string]$Password
		)
		set-variable -name PRTGHost -value $PRTGHost -scope Global
        if ($Password -and !$Passhash) {
        $url = "https://$PRTGHost/api/getpasshash.htm?username=$User&password=$Password"
	    $Passhash = Invoke-WebRequest -Uri $url -MaximumRedirection 0 
        $auth = "username="+$User+"&passhash="+$Passhash      
        } 
        elseif (!$Password -and $Passhash){
		$auth = "username="+$User+"&passhash="+$Passhash
		}
        elseif ($Password -and $Passhash){
		write-host "you must provide either a user Password OR a user Passhash (Not both)"
		}
        else {
        write-host "you must provide either a user Password OR a user Passhash."
        }
        set-variable -name auth -value $auth -scope Global
}