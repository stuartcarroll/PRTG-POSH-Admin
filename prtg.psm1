
#
# PRTG POSH Admin 0.1 
# author: stuart@stuartc.net
# 

function Ignore-SSLCertificates
{
    $Provider = New-Object Microsoft.CSharp.CSharpCodeProvider
    $Compiler = $Provider.CreateCompiler()
    $Params = New-Object System.CodeDom.Compiler.CompilerParameters
    $Params.GenerateExecutable = $false
    $Params.GenerateInMemory = $true
    $Params.IncludeDebugInformation = $false
    $Params.ReferencedAssemblies.Add("System.DLL") > $null
    $TASource=@'
        namespace Local.ToolkitExtensions.Net.CertificatePolicy
        {
            public class TrustAll : System.Net.ICertificatePolicy
            {
                public bool CheckValidationResult(System.Net.ServicePoint sp,System.Security.Cryptography.X509Certificates.X509Certificate cert, System.Net.WebRequest req, int problem)
                {
                    return true;
                }
            }
        }
'@ 
    $TAResults=$Provider.CompileAssemblyFromSource($Params,$TASource)
    $TAAssembly=$TAResults.CompiledAssembly
    ## We create an instance of TrustAll and attach it to the ServicePointManager
    $TrustAll = $TAAssembly.CreateInstance("Local.ToolkitExtensions.Net.CertificatePolicy.TrustAll")
    [System.Net.ServicePointManager]::CertificatePolicy = $TrustAll
}

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

function Clone-PrtgFromDeviceToGroup
{
	Param(
        [Parameter(Mandatory=$true)]
        [string]$Simulate,
		[string]$SourceDevice,
		[string]$SourceProbe,
		[string]$DestinationGroup,
		[string]$DestinationProbe
		)

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
            else{
            write-host "Cloned Sensor Name:"
            write-host $Sensor.sensor
            write-host "Cloned Sensor ID:"
            write-host $Sensor.objid

            $url = "https://$PRTGHost/api/duplicateobject.htm?id=$Senobjid&name=$SenName&targetid=$DevObjid&$auth"
	        $request = Invoke-WebRequest -Uri $url -MaximumRedirection 0 -ErrorAction ignore
	        
            }

        }
    }
}    



