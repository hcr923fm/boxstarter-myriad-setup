$sqlServerInstallArgs='/BROWSERSVCSTARTUPTYPE=Automatic'
$sqlServerDataRootPathOverride = Read-Host -Prompt "Where should the SQL Server Data Root Directory be, if overriding? [ $env:ProgramFiles\Microsoft SQL Server ]"
if($sqlServerDataRootPathOverride){$sqlServerInstallArgs += " /INSTALLSQLDATADIR=`"`"${sqlServerDataRootPathOverride}`"`""}

$sqlServerUserPassOverride= Read-Host -Prompt "Enter a password for the SQL Server system admin account (leave blank to disable Mixed Mode authentication)"
if($sqlServerUserPassOverride){$sqlServerInstallArgs += " /SECURITYMODE=SQL /SAPWD=`"`"$sqlServerUserPassOverride`"`""}

Write-Host "Installing SQL Server Express 2016 and SQL Server Management Suite" -ForegroundColor Yellow
cinst sql-server-express --version=13.1.4001.0 -y -ia "'$sqlServerInstallArgs'"
cinst ssms -y

Write-Host "Setting firewall rules for SQL Server Express 2016 and SQL Server Management Suite" -ForegroundColor Yellow

$sqlServerExec=(Get-ChildItem -Path "$env:ProgramFiles;${env:ProgramFiles(x86)};$env:Path;$sqlServerDataRootPathOverride".Split(';') -R "sqlservr.exe" -ErrorAction Ignore | Select-Object -First 1).FullName
if($sqlServerExec){
    New-NetFirewallRule -DisplayName "Allow SQL Server Express" -Action Allow -Direction Inbound -Profile Any -Program $sqlServerExec
} else {
    Write-Host "Warning - could not find sqlservr.exe! It can usually be found under `"C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\Binn\sqlservr.exe`"" -ForegroundColor Red
    Write-Host "You will need to create the inbound firewall rules yourself." -ForegroundColor Red
}

$ssmExec=(Get-ChildItem -Path "$env:ProgramFiles;${env:ProgramFiles(x86)};$env:Path".Split(';') -R "sqlbrowser.exe" -ErrorAction Ignore | Select-Object -First 1).FullName
if($ssmExec){
    New-NetFirewallRule -DisplayName "Allow SQL Server Management Suite" -Action Allow -Direction Inbound -Profile Any -Program $ssmExec
} else {
    Write-Host "Warning - could not find sqlbrowser.exe! It can usually be found under `"C:\Program Files (x86)\Microsoft SQL Server\90\Shared\sqlbrowser.exe`"" -ForegroundColor Red
    Write-Host "You will need to create the inbound firewall rules yourself." -ForegroundColor Red
}