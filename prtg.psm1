
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
	$xml.groups.item
}

function Get-PrtgSensors
{
	$url = "https://$PRTGHost/api/table.xml?content=sensors&output=xml&columns=objid,probe,group,device,sensor,status,message,lastvalue,priority,favorite&$auth"
	$request = Invoke-WebRequest -Uri $url -MaximumRedirection 0 -SkipCertificateCheck
	[xml]$xml = $request
	$xml.sensors.Item
}


function Get-PrtgDevices
{
	$url = "https://$PRTGHost/api/table.xml?content=devices&output=xml&columns=objid,probe,group,device,host&$auth"
	$request = Invoke-WebRequest -Uri $url -MaximumRedirection 0 -SkipCertificateCheck
	[xml]$xml = $request
	$xml.devices.Item
}
