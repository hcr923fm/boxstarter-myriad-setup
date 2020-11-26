# boxstarter-myriad-setup

Want to install Broadcast Radio Myriad v5?
Install BoxStarter, then call `setup.ps1`:
`Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/hcr923fm/boxstarter-myriad-setup/master/setup.ps1'))`

On the machine you're installing onto, remember to run the following first:
`Set-NetConnectionProfile -NetworkCategory Private`
`Set-WSManQuickConfig -Force`
`Set-Item WSMan:\localhost\Client\TrustedHosts -Value "HOST-PC-IP" -Force`

And on the machine you're installing from:
`Set-Item WSMan:\localhost\Client\TrustedHosts -Value "GUEST-PC-IP" -Force`

# Options
`NoInstallSetup` - don't install utility software, setup windows explorer, or remove cruft software
`-InstallMyriadServerDeps` - install SQL Server Express and SQL Server Management Suite
`-DownloadMyriadServerFiles` - download the Myriad Playout software installers, with AutoTrack and OCP
`-DownloadMyriadClientFiles` - download the Myriad Playout software installers
`-SqlServerDataRootDir` - when installing the SQL Server Express, override the default data directory, as recommended by the BR guide
`-SqlServerSysAdminPass` - when installing the SQL Server Express, set the admin user password
`-ComputerName` - the IP of the machine to install onto