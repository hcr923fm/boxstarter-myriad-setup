Param(
[switch] $NoInstallSetup,
[switch] $InstallMyriadServerDeps,
[switch] $DownloadMyriadServerFiles,
[switch] $DownloadMyriadClientFiles,
[string] $SqlServerDataRootDir,
[string] $SqlServerSysAdminPass,
[string] $ComputerName
)

$ErrorActionPreference="Continue"
$scriptsUrlRoot="https://raw.githubusercontent.com/hcr923fm/boxstarter-myriad-setup/master/"
$cred=Get-Credential

if(!$NoInstallSetup){
    Install-BoxstarterPackage -ComputerName $ComputerName -Credential $cred -PackageName "$scriptsUrlRoot/scripts/basic_setup.ps1"
    Install-BoxstarterPackage -ComputerName $ComputerName -Credential $cred -PackageName "$scriptsUrlRoot/scripts/set_ccleaner_scheduled_task.ps1"
}

if($InstallMyriadServerDeps){
    if($SqlServerDataRootDir){
        Invoke-Command -ComputerName $ComputerName -Credential $cred -ScriptBlock { Write-Output "$Using:SqlServerDataRootDir" | Out-File C:/SqlServerDataRootDir.txt }
    } else { Write-Host "Not setting an override value for the SQL Server Data Root directory. To override, pass '-SqlServerDataRootDir DRV:\Path\To\Dir" -ForegroundColor Magenta }
    if($SqlServerSysAdminPass){
        Invoke-Command -ComputerName $ComputerName -Credential $cred -ScriptBlock { Write-Output "$Using:SqlServerSysAdminPass" | Out-File C:/SqlServerSysAdminPass.txt }
    } else { Write-Host "Not setting an admin password for the SQL Server sysadmin. To override, pass '-SqlServerSysAdminPass PasswordHere" -ForegroundColor Magenta }
    
    Install-BoxstarterPackage -ComputerName $ComputerName -Credential $cred -PackageName "$scriptsUrlRoot/scripts/myriad_server_deps_install.ps1"

    if($SqlServerDataRootDir){
        Invoke-Command -ComputerName $ComputerName -Credential $cred -ScriptBlock { rm C:/SqlServerDataRootDir.txt }
    }
    if($SqlServerSysAdminPass){
        Invoke-Command -ComputerName $ComputerName -Credential $cred -ScriptBlock { rm C:/SqlServerSysAdminPass.txt }
    }
}

if($DownloadMyriadServerFiles){
    Install-BoxstarterPackage -ComputerName $ComputerName -Credential $cred -PackageName "$scriptsUrlRoot/scripts/myriad_server_download.ps1"
}

if($DownloadMyriadClientFiles){
    Install-BoxstarterPackage -ComputerName $ComputerName -Credential $cred -PackageName "$scriptsUrlRoot/scripts/myriad_client_download.ps1"
}