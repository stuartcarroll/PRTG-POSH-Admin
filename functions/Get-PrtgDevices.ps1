function Get-PrtgDevices
{
	Param(
		[string]$Name,
		[string]$Group,
		[string]$Host,
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

	$url = "https://$PRTGHost/api/table.xml?content=devices&output=xml&columns=objid,probe,group,device,host&$auth"
	$request = Invoke-WebRequest -Uri $url -MaximumRedirection 0
	[xml]$xml = $request

		if ($Name -and $Group -and $Probe) {
			$xml.devices.Item | ? { $_.device -eq $Name } | ? { $_.group -eq $Group } | ? { $_.probe -eq $Probe }
		}
        elseif ($Name -and $Group) {
			$xml.devices.Item | ? { $_.device -eq $Name } | ? { $_.group -eq $Group }
		}
        elseif ($Name -and $Probe) {
			$xml.devices.Item | ? { $_.device -eq $Name } | ? { $_.probe -eq $Probe }
		}
        elseif ($Name) {
			$xml.devices.Item| ? { $_.device -eq $Name }
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