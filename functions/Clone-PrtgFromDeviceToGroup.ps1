function Delete-AllSensorsFrom
{
	Param(
        [Parameter(Mandatory=$true)]
        [string]$Simulate,
		[string]$SourceDevice,
		[string]$SourceProbe,
		[string]$DestinationGroup,
		[string]$DestinationProbe
		)

    if (!$auth){
        write-host "No Auth string is set."
        $PRTGHost= Read-Host "PRTG Server"
        $User= Read-Host "PRTG User"
        $Password= Read-Host "PRTG User Password"
        Set-PrtgAuth -PRTGHost $PRTGHost -User $User -Password $Password$auth
        }

    $Source = Get-PrtgSensors -Device $SourceDevice -Probe $SourceProbe
    $Destination = Get-PrtgDevices -Probe $DestinationProbe -Group $DestinationGroup

    foreach ($Device in $Destination) {

        write-host "Destination Device Name:"
        write-host $Device.device
        write-host "Destination Device ID:"
        $DevObjid = $Device.objid
        write-host $DevObjid
    
        foreach ($Sensor in $Source) {
            $SenName = $Sensor.sensor
            $SenObjid = $Sensor.objid
            if ($Simulate -eq "on"){
            write-host "Cloned Sensor Name:"
            write-host $SenName
            write-host "Cloned Sensor ID:"
            write-host $SenObjid
            }
            write-host "Cloned Sensor Name:"
            write-host $SenName
            write-host "Cloned Sensor ID:"
            write-host $SenObjid

            $url = "https://$PRTGHost/api/duplicateobject.htm?id=$Senobjid&name=$SenName&targetid=$DevObjid&$auth"
	        $request = Invoke-WebRequest -Uri $url -MaximumRedirection 0 -ErrorAction ignore
	        
            }

        }
    }
}    