function Get-PrtgGroups
{

	Param(
		[string]$Name,
		[string]$Probe,
		[string]$ID
		)

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