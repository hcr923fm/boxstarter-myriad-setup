$scriptsUrlRoot="https://raw.githubusercontent.com/hcr923fm/boxstarter-myriad-setup/master/"
function executeScript {
    Param ([string]$script)
    write-host "executing $script ..."
	iex ((new-object net.webclient).DownloadString("$script"))
}

#$ServerName = Read-Host -Prompt "Which machine are we installing on? [ $env:COMPUTERNAME ]"
#if (!$ServerName) { $ServerName= $env:COMPUTERNAME }
#$UserName = Read-Host -Prompt "Which user should the install script run as? [ $env:USERNAME ]"
#if (!$UserName) { $UserName= $env:USERNAME }

#$Cred=Get-Credential "${UserName}"


# Do some generic defucking of Windows
#Write-Host "Installing chocolatey" -ForegroundColor Yellow
#Install-BoxstarterPackage -PackageName "$scriptsUrlRoot/scripts/install_chocolatey.ps1"-ComputerName $ServerName -Credential $Cred -DisableReboots
Write-Host "Setting up Windows Explorer" -ForegroundColor Yellow
#Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/microsoft/windows-dev-box-setup-scripts/master/scripts/FileExplorerSettings.ps1 -ComputerName $ServerName -Credential $Cred -DisableReboots
executeScript "https://raw.githubusercontent.com/microsoft/windows-dev-box-setup-scripts/master/scripts/FileExplorerSettings.ps1"

Write-Host "Removing cruft apps" -ForegroundColor Yellow
#Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/microsoft/windows-dev-box-setup-scripts/master/scripts/RemoveDefaultApps.ps1 -ComputerName $ServerName -Credential $Cred -DisableReboots
executeScript "https://raw.githubusercontent.com/microsoft/windows-dev-box-setup-scripts/master/scripts/RemoveDefaultApps.ps1"

Write-Host "Disabling unnecessary features and installing aria2" -ForegroundColor Yellow
#Install-BoxstarterPackage -PackageName "$scriptsUrlRoot/scripts/enable_utilities.ps1"-ComputerName $ServerName -Credential $Cred -DisableReboots
executeScript "$scriptsUrlRoot/scripts/enable_utilities.ps1"

Write-Host "Installing useful web browsers" -ForegroundColor Yellow
executeScript "https://github.com/microsoft/windows-dev-box-setup-scripts/blob/master/scripts/Browsers.ps1"

$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

# Set CCleaner Scheduled Task
$setCCleanerSchedTask = $Host.UI.PromptForChoice("", "Set CCleaner scheduled task?", $choices, 1)
if($setCCleanerSchedTask -eq 0){ executeScript "$scriptsUrlRoot/scripts/set_ccleaner_scheduled_task.ps1"}

# Set Chocolately Scheduled Task
#$setChocoSchedTask = $Host.UI.PromptForChoice("", "Set Chocolatey auto-update scheduled task?", $choices, 1)
#if($setChocoSchedTask -eq 0){ Install-BoxstarterPackage -PackageName "$scriptsUrlRoot/scripts/set_choco_scheduled_task.ps1"-ComputerName $ServerName -Credential $Cred }

# Install Myriad server deps, if necessary
Write-Host "Warning - only install Myriad Playout Server 5 deps if the Myriad data partition has already been created." -ForegroundColor Red
$installMyriadServerDeps = $Host.UI.PromptForChoice("", "Install Myriad Playout 5 server dependencies?", $choices, 1)
if($installMyriadServerDeps -eq 0){ executeScript "$scriptsUrlRoot/scripts/myriad_server_deps_install.ps1"}

# Download Myriad v5 server binaries
$installMyriadServerBins = $Host.UI.PromptForChoice("", "Install Myriad Playout 5 server binaries?", $choices, 1)
if($installMyriadServerBins -eq 0){executeScript "$scriptsUrlRoot/scripts/myriad_server_download.ps1" }

# Install Myriad client deps, if necessary
# Download Myriad v5 server binaries
$installMyriadClientBins = $Host.UI.PromptForChoice("", "Install Myriad Playout 5 client binaries?", $choices, 1)
if($installMyriadClientBins -eq 0){ executeScript "$scriptsUrlRoot/scripts/myriad_client_download.ps1" }

# Reboot
$reboot = $Host.UI.PromptForChoice("", "Reboot?", $choices, 0)
if($reboot -eq 0){Invoke-Reboot}
