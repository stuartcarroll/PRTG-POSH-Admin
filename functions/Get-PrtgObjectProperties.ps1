function Get-PrtgObjectProperties
{
	Param(
        [Parameter(Mandatory=$true)]
		[string]$ObjectID
		)

    if (!$auth)
    {
        write-host "No Auth string is set."
        $PRTGHost= Read-Host "PRTG Server"
        $User= Read-Host "PRTG User"
        $Password= Read-Host "PRTG User Password"
        Set-PrtgAuth -PRTGHost $PRTGHost -User $User -Password $Password$auth
    }

    $url = "https://$PRTGHost/api/table.xml?content=sensortree&output=xml&id=$ObjectID&$auth"
    $request = Invoke-WebRequest -Uri $url -MaximumRedirection 0
    [xml]$xml = $request

    $xml
    
}    