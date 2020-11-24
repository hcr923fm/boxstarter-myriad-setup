$ServerName = Read-Host -Prompt "Which machine are we installing on? [ $env:COMPUTERNAME ]"
if (!$ServerName) { $ServerName= $env:COMPUTERNAME }
$UserName = Read-Host -Prompt "Which user should the install script run as? [ $env:USERNAME ]"
if (!$UserName) { $UserName= $env:USERNAME }

$Cred=Get-Credential "${ServerName}\${UserName}"
$scriptsUrlRoot="https://raw.githubusercontent.com/hcr923fm/boxstarter-myriad-setup/master/"

# Do some generic defucking of Windows
Write-Host "Setting up Windows Explorer" -ForegroundColor Yellow
Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/microsoft/windows-dev-box-setup-scripts/master/scripts/FileExplorerSettings.ps1 -ComputerName $ServerName -Credential $Cred -DisableReboots
Write-Host "Removing cruft apps" -ForegroundColor Yellow
Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/microsoft/windows-dev-box-setup-scripts/master/scripts/RemoveDefaultApps.ps1 -ComputerName $ServerName -Credential $Cred -DisableReboots
Write-Host "Disabling unnecessary features and installing aria2" -ForegroundColor Yellow
Install-BoxstarterPackage -PackageName "$scriptsUrlRoot/scripts/enable_utilities.ps1"-ComputerName $ServerName -Credential $Cred -DisableReboots
Write-Host "Installing useful web browsers" -ForegroundColor Yellow
Install-BoxstarterPackage -PackageName https://github.com/microsoft/windows-dev-box-setup-scripts/blob/master/scripts/Browsers.ps1 -ComputerName $ServerName -Credential $Cred -DisableReboots

# Install Myriad server deps, if necessary
Write-Host "Warning - only install Myriad Playout Server 5 deps if the Myriad data partition has already been created." -ForegroundColor Red
$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$installMyriadServerDeps = $Host.UI.PromptForChoice("", "Install Myriad Playout 5 server dependencies?", $choices, 1)
if($installMyriadServerDeps -eq 0){ Install-BoxstarterPackage -PackageName "$scriptsUrlRoot/scripts/myriad_server_deps_install.ps1"-ComputerName $ServerName -Credential $Cred }

# Download Myriad v5 server binaries
$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$installMyriadServerBins = $Host.UI.PromptForChoice("", "Install Myriad Playout 5 server binaries?", $choices, 1)
if($installMyriadServerBins -eq 0){ Install-BoxstarterPackage -PackageName "$scriptsUrlRoot/scripts/myriad_server_download.ps1"-ComputerName $ServerName -Credential $Cred }

# Install Myriad client deps, if necessary
# Download Myriad v5 server binaries
$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$installMyriadClientBins = $Host.UI.PromptForChoice("", "Install Myriad Playout 5 client binaries?", $choices, 1)
if($installMyriadClientBins -eq 0){ Install-BoxstarterPackage -PackageName "$scriptsUrlRoot/scripts/myriad_client_download.ps1"-ComputerName $ServerName -Credential $Cred }

Invoke-Reboot