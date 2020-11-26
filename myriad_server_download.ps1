cd $env:USERPROFILE\Desktop

Write-Host "Downloading Myriad Playout v5" -ForegroundColor Yellow
aria2c https://support.broadcastradio.com/Products/Myriad/v5/v5.24.20293/Playout/BRMyriadPlayout5.msi

Write-Host "Downloading Myriad Scheduling SE v5" -ForegroundColor Yellow
aria2c https://support.broadcastradio.com/Products/Myriad/v4.5/SE/v4.5.24/SchedulingSE/BRMyriadSchedulingSE45.msi

Write-Host "Downloading Myriad OCP SE v4" -ForegroundColor Yellow
aria2c https://support.broadcastradio.com/Products/Myriad/v4.5/SE/v4.5.24/OCPSE/BRMyriadOCPSE45.msi