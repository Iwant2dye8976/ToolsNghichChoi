$scriptPath = $PSScriptRoot
$xmlPath = "$scriptPath\Unlock.xml"
$bat_file = "$scriptPath\Remove.bat"
[xml]$xml = Get-Content $xmlPath
$xml.Task.Actions.Exec.Command = $bat_file
$xml.Save($xmlPath)