
#
# PRTG POSH Admin 0.1 
# author: stuart@stuartc.net
# 

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

function Get-PrtgGroups
{

	Param(
		[string]$Name,
		[string]$Probe,
		[string]$ID
		)

	$url = "https://$PRTGHost/api/table.xml?content=groups&output=xml&columns=objid,probe,group&$auth"
	$request = Invoke-WebRequest -Uri $url -MaximumRedirection 0 -SkipCertificateCheck
	[xml]$xml = $request

		if ($Name) {
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

function Get-PrtgSensors
{
	Param(
		[string]$Name,
		[string]$Group,
		[string]$Device,
		[string]$Probe,
		[string]$ID,
		[string]$Status
		)

	$url = "https://$PRTGHost/api/table.xml?content=sensors&output=xml&columns=objid,probe,group,device,sensor,status,message,lastvalue,priority,favorite&$auth"
	$request = Invoke-WebRequest -Uri $url -MaximumRedirection 0 -SkipCertificateCheck
	[xml]$xml = $request

		if ($Name) {
			$xml.sensors.Item | ? { $_.sensor -eq $Name }
		}
		elseif ($Group) {
			$xml.sensors.Item| ? { $_.group -eq $Group }
		}
		elseif ($Device) {
			$xml.sensors.Item | ? { $_.device -eq $Device }
		}
		elseif ($Probe) {
			$xml.sensors.Item | ? { $_.probe -eq $Probe }
		}
		elseif ($ID) {
			$xml.sensors.Item | ? { $_.objid -eq $ID }
		}
		elseif ($Status) {
			$xml.sensors.Item | ? { $_.status -eq $Status }
		}
		else {
		$xml.sensors.Item
		}
	
}


function Get-PrtgDevices
{
	Param(
		[string]$Name,
		[string]$Group,
		[string]$Host,
		[string]$Probe,
		[string]$ID
		)

	$url = "https://$PRTGHost/api/table.xml?content=devices&output=xml&columns=objid,probe,group,device,host&$auth"
	$request = Invoke-WebRequest -Uri $url -MaximumRedirection 0 -SkipCertificateCheck
	[xml]$xml = $request

		if ($Name) {
			$xml.devices.Item | ? { $_.device -eq $Name }
		}
		elseif ($Group) {
			$xml.devices.Item| ? { $_.group -eq $Group }
		}
		elseif ($Host) {
			$xml.devices.Item | ? { $_.host -eq $Host }
		}
		elseif ($Probe) {
			$xml.devices.Item | ? { $_.probe -eq $Probe }
		}
		elseif ($ID) {
			$xml.devices.Item | ? { $_.objid -eq $ID }
		}
		else {
		$xml.devices.Item
		}
	
}
