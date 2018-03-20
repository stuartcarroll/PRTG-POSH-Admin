<#
.SYNOPSIS
Get PRTG Sensor Data

.DESCRIPTION
Queries PRTG server for sensor paramters which can be used in other PRTG functions to automate the configuraion of multiple devices within device groups

.PARAMETER Name
Device Sensor Name
.PARAMETER Probe
Name of Probe the Sensor is bound to 
.PARAMETER Device
Name of Device the Sensor is bound to 
.PARAMETER Group
Name of Group the Sensor is bound to
.PARAMETER ID
PRTG Probe object ID
.PARAMETER Status
PRTG sensor status

.EXAMPLE

Get all PRTG Sensors:

Get-PrtgSensors

.EXAMPLE

Get PRTG Sensors by name

Get-PrtgSensors -Name <Sensor Name>

.EXAMPLE

Get PRTG Sensors by Device

Get-PrtgSensors -Device <Device Name>

.EXAMPLE

Get PRTG Sensors from a device in a specific Probe

Get-PrtgSensors -Device <Device Name> -Probe <Probe Name>

.EXAMPLE

Get PRTG Sensors from a device in a specific Group and Probe

Get-PrtgSensors -Device <Device Name> -Probe <Probe Name> -Group <Group Name>
#>


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

    if (!$auth){
        write-host "No Auth string is set."
        $PRTGHost= Read-Host "PRTG Server"
        $User= Read-Host "PRTG User"
        $Password= Read-Host "PRTG User Password"
        Set-PrtgAuth -PRTGHost $PRTGHost -User $User -Password $Password$auth
        }

	$url = "https://$PRTGHost/api/table.xml?content=sensors&output=xml&columns=objid,probe,group,device,sensor,status,message,lastvalue,priority,favorite&$auth"
	$request = Invoke-WebRequest -Uri $url -MaximumRedirection 0
	[xml]$xml = $request

		if ($Name -and $Group -and -$Probe -and $Device) {
			$xml.sensors.Item |  ? { $_.sensor -eq $Name } |  ? { $_.group -eq $Group } |  ? { $_.probe -eq $Probe } |  ? { $_.device -eq $Device }
		}
        elseif ($Name -and $Probe -and $Device) {
			$xml.sensors.Item |  ? { $_.sensor -eq $Name } |  ? { $_.probe -eq $Probe } |  ? { $_.device -eq $Device }
		}
        elseif ($Probe -and $Device) {
			$xml.sensors.Item |  ? { $_.probe -eq $Probe } |  ? { $_.device -eq $Device }
		}
        elseif ($Name) {
			$xml.sensors.Item |  ? { $_.sensor -eq $Name }
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
            $Status = $Status+" "
			$xml.sensors.Item | ? { $_.status -eq $Status }
		}
		else {
		$xml.sensors.Item
		}
	
}
