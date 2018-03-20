
#Load functions

$moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path
"$moduleRoot\Functions\*.ps1*" |
    Resolve-Path | 
    ForEach-Object { . $_.ProviderPath }

Export-ModuleMember *prtg*















