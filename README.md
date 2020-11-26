# boxstarter-myriad-setup

Want to install Broadcast Radio Myriad v5?
Install BoxStarter, then call `basic_setup.ps1`.

On the machine you're installing onto, remember to run the following first:
`Set-NetConnectionProfile -NetworkCategory Private`
`Set-WSManQuickConfig -Force`
`Set-Item WSMan:\localhost\Client\TrustedHosts -Value "HOST-PC-IP" -Force`

And on the machine you're installing from:
`Set-Item WSMan:\localhost\Client\TrustedHosts -Value "GUEST-PC-IP" -Force`