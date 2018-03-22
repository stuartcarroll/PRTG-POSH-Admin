function Duplicate-PrtgDevice
{
	Param(
        [Parameter(Mandatory=$true)]
        [string]$Simulate,
        [Parameter(Mandatory=$true)]
        [string]$SourceDevice,
        [Parameter(Mandatory=$true)]
        [string]$SourceProbe,
        [Parameter(Mandatory=$true)]
		[string]$DeviceGroup,
        [Parameter(Mandatory=$true)]
        [string]$GroupProbe,
        [Parameter(Mandatory=$true)]
        [string]$Devices
		)

    if (!$auth)
    {
        write-host "No Auth string is set."
        $PRTGHost= Read-Host "PRTG Server"
        $User= Read-Host "PRTG User"
        $Password= Read-Host "PRTG User Password"
        Set-PrtgAuth -PRTGHost $PRTGHost -User $User -Password $Password$auth
    }

    $Source = (Get-PrtgDevices -Name $SourceDevice -Probe $SourceProbe).objid
    $Destination = (get-prtggroups -Name $DeviceGroup -Probe $GroupProbe).objid


        foreach ($Device in $Devices.split(",")) 
        {

            if ($Simulate -eq "on"){
                write-host "Create Device:"
                write-host $Device
                write-host "https://"$PRTGHost"/api/duplicateobject.htm?id="$SourceDeviceID"&name="$Device"&host="$Device"&targetid="$Destination"&"$auth
                }
                else
                {
                write-host "Creating Device:"
                write-host $Device

                $url = "https://$PRTGHost/api/duplicateobject.htm?id=$Source&name=$Device&host=$Device&targetid=$Destination&$auth"
                $request = Invoke-WebRequest -Uri $url -MaximumRedirection 0 -ErrorAction ignore
            
            }
        }

    
}    