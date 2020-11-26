Write-Host "Creating CCleaner scheduled task for Sunday, 2am" -ForegroundColor Yellow
Write-Host "Finding CCleaner binary..."

$ccleanerExec=(Get-ChildItem -Path "$env:ProgramFiles;${env:ProgramFiles(x86)};$env:Path".Split(';') -R "ccleaner.exe" -ErrorAction Ignore | Select-Object -First 1).FullName
if($ccleanerExec){
$Action = New-ScheduledTaskAction -Execute $ccleanerExec -Argument "/AUTO"
$Trigger = New-ScheduledTaskTrigger -At 2am -Weekly -DaysOfWeek Sunday
$Principal = New-ScheduledTaskPrincipal -UserId $env:COMPUTERNAME\$env:USERNAME
$SettingsSet= New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Hours 1) -MultipleInstances IgnoreNew -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 5) -StartWhenAvailable -WakeToRun
$Task=New-ScheduledTask -Action $Action -Principal $Principal -Settings $SettingsSet -Trigger $Trigger
Register-ScheduledTask -TaskName "CCleaner Auto Scan" -InputObject $Task -TaskPath "HCR"
} else {
    Write-Host "Warning - could not find ccleaner.exe!" -ForegroundColor Red
    Write-Host "You will need to create the scheduled task yourself." -ForegroundColor Red
}