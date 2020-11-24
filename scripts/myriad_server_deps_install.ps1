$sqlServerInstallArgs='/BROWSERSVCSTARTUPTYPE=Automatic'
$sqlServerDataRootPathOverride = Read-Host -Prompt "Where should the SQL Server Data Root Directory be, if overriding? [ $env:ProgramFiles\Microsoft SQL Server ]"
if($sqlServerDataRootPathOverride){$sqlServerInstallArgs += " /INSTALLSQLDATADIR=`"`"${sqlServerDataRootPathOverride}`"`""}

$sqlServerUserPassOverride= Read-Host -Prompt "Enter a password for the SQL Server system admin account (leave blank to disable Mixed Mode authentication)"
if($sqlServerUserPassOverride){$sqlServerInstallArgs += " /SECURITYMODE=SQL /SAPWD=`"`"$sqlServerUserPassOverride`"`""}

Write-Host "Installing SQL Server Express 2016 and SQL Server Management Suite" -ForegroundColor Yellow
cinst sql-server-express --version=13.1.4001.0 -y -ia "'$sqlServerInstallArgs'"
cinst ssms -y

Write-Host "Setting firewall rules for SQL Server Express 2016 and SQL Server Management Suite" -ForegroundColor Yellow

$sqlServerExecCandidates = Get-ChildItem -Path "$env:ProgramFiles" -R "sqlservr.exe"
if(!$sqlServerExecCandidates){$sqlServerExecCandidates = Get-ChildItem -Path "${env:ProgramFiles(x86)}" -R "sqlservr.exe"}
if(!$sqlServerExecCandidates -And $sqlServerDataRootPathOverride){$sqlServerExecCandidates = Get-ChildItem -Path "$sqlServerDataRootPathOverride" -R "sqlservr.exe"}
if($sqlServerExecCandidates){
    New-NetFirewallRule -DisplayName "Allow SQL Server Express" -Action Allow -Direction Inbound -Profile Any -Program $sqlServerExecCandidates[0].FullName
    } else {
    Write-Host "Warning - could not find sqlservr.exe! It can usually be found under `"C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\Binn\sqlservr.exe`"" -ForegroundColor Red
    Write-Host "You will need to create the inbound firewall rules yourself." -ForegroundColor Red
}

$ssmExecCandidates = Get-ChildItem -Path "$env:ProgramFiles" -R "sqlbrowser.exe"
if(!$ssmExecCandidates){$ssmExecCandidates = Get-ChildItem -Path "${env:ProgramFiles(x86)}" -R "sqlbrowser.exe"}
if($ssmExecCandidates){
    New-NetFirewallRule -DisplayName "Allow SQL Server Management Suite" -Action Allow -Direction Inbound -Profile Any -Program $ssmExecCandidates[0].FullName
    } else {
    Write-Host "Warning - could not find sqlbrowser.exe! It can usually be found under `"C:\Program Files (x86)\Microsoft SQL Server\90\Shared\sqlbrowser.exe`"" -ForegroundColor Red
    Write-Host "You will need to create the inbound firewall rules yourself." -ForegroundColor Red
}