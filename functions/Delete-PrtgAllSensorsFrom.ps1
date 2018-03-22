function Delete-PrtgAllSensorsFrom
{
	Param(
        [Parameter(Mandatory=$true)]
        [string]$Simulate,
		[string]$Device,
		[string]$DeviceGroup,
        [Parameter(Mandatory=$true)]
		[string]$Probe
		)

    if (!$auth)
    {
        write-host "No Auth string is set."
        $PRTGHost= Read-Host "PRTG Server"
        $User= Read-Host "PRTG User"
        $Password= Read-Host "PRTG User Password"
        Set-PrtgAuth -PRTGHost $PRTGHost -User $User -Password $Password$auth
    }

    if ($Device -and $DeviceGroup)
    {
        write-host "Define either Device OR Group, not both."
    } 
    elseif ($Device -and !$DeviceGroup -and $Probe)
    {
        write-host "Deleting all sensors from "$Device" on "$Probe
        $Sensors= Get-PrtgSensors -Device $Device -Probe $Probe

        foreach ($Sensor in $Sensors) 
        {
            $SenName = $Sensor.sensor
            $SenObjid = $Sensor.objid
            if ($Simulate -eq "on"){
                write-host "Delete Sensor Name:"
                write-host $SenName
                write-host "Delete Sensor ID:"
                write-host $SenObjid
                }
                else
                {
                write-host "Delete Sensor Name:"
                write-host $SenName
                write-host "Delete Sensor ID:"
                write-host $SenObjid

                $url = "https://$PRTGHost/api/deleteobject.htm?id=$SenObjid&approve=1&$auth"
                $request = Invoke-WebRequest -Uri $url -MaximumRedirection 0 -ErrorAction ignore
            
            }
        }
    } 
    elseif ($DeviceGroup -and !$Device -and $Probe)
    {
        write-host "Deleting all sensors from "$DeviceGroup" on "$Probe
        $Devices = Get-PrtgDevices -Probe $Probe -Group $DeviceGroup
        foreach ($Dev in $Devices)
        {

            write-host "Device Name:"
            $DevName = $Dev.device
            write-host $DevName
            write-host "Device ID:"
            $DevObjid = $Dev.objid
            write-host $DevObjid

            $Sensors = Get-PrtgSensors -Device $DevName -Probe $Probe
        
            foreach ($Sensor in $Sensors) 
            {
                $SenName = $Sensor.sensor
                $SenObjid = $Sensor.objid
                if ($Simulate -eq "on")
                {
                    write-host "Delete Sensor Name:"
                    write-host $SenName
                    write-host "Delete Sensor ID:"
                    write-host $SenObjid
                }
                else
                {
                    write-host "Delete Sensor Name:"
                    write-host $SenName
                    write-host "Delete Sensor ID:"
                    write-host $SenObjid

                    $url = "https://$PRTGHost/api/deleteobject.htm?id=$SenObjid&approve=1&$auth"
                    $request = Invoke-WebRequest -Uri $url -MaximumRedirection 0 -ErrorAction ignore
                
                }

            }
        }
    } 
    elseif (!$Device -and !$DeviceGroup)
    {
        write-host "Define either Device OR Group, not both."
    }
    else 
    {
        write-host "Something went wrong"
    }
    
}    