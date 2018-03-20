<#
.SYNOPSIS
Get PRTG Group Object ID, Name and Probe

.DESCRIPTION
Queries PRTG server for device group paramters which can be used in other PRTG functions to automate the configuraion of multiple devices within device groups

.PARAMETER Name
Device Group Name
.PARAMETER Probe
PRTG Probe name 
.PARAMETER ID
PRTG Group object ID

.EXAMPLE

Get all PRTG Groups:

Get-PrtgGroups

.EXAMPLE

Get PRTG Group by Name 

Get-PrtgGroups -Name <GroupName>

.EXAMPLE

Get PRTG Group by Object ID

Get-PrtgGroups -ID <Object ID>

.EXAMPLE

Get all PRTG Groups within a specifc probe

Get-PrtgGroups -Probe <Probe Name>


.EXAMPLE

Get PRTG Group within a specifc probe

Get-PrtgGroups -Name <GroupName> -Probe <Probe Name>

.Notes

You need this function to set the auth variable for other PRTG functions in this module.

#>

function Get-PrtgGroups
{

	Param(
		[string]$Name,
		[string]$Probe,
		[string]$ID
		)

    if (!$auth){
        write-host "No Auth string is set."
        $PRTGHost= Read-Host "PRTG Server"
        $User= Read-Host "PRTG User"
        $Password= Read-Host "PRTG User Password"
        Set-PrtgAuth -PRTGHost $PRTGHost -User $User -Password $Password$auth
        }
        

	    $url = "https://$PRTGHost/api/table.xml?content=groups&output=xml&columns=objid,probe,group&$auth"
	    $request = Invoke-WebRequest -Uri $url -MaximumRedirection 0
	    [xml]$xml = $request

		    if ($Name -and $Probe) {
			    $xml.groups.item | ? { $_.group -eq $Name } | ? { $_.probe -eq $Probe }
		    }
		    elseif ($Name) {
			    $xml.groups.item | ? { $_.group -eq $Name }
		    }
		    elseif ($Probe) {
			    $xml.groups.item | ? { $_.probe -eq $Probe }
		    }
		    elseif ($ID) {
			    $xml.groups.item | ? { $_.objid -eq $ID }
		    }
		    else {
		    $xml.groups.item
		    }

}