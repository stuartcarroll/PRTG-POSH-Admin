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
