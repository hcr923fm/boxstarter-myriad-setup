cd $env:USERPROFILE\Desktop

Write-Host "Downloading Myriad Playout v5" -ForegroundColor Yellow
aria2c https://support.broadcastradio.com/Products/Myriad/v5/v5.24.20293/Playout/BRMyriadPlayout5.msi

Write-Host "Downloading BootStuff" -ForegroundColor Yellow
aria2c https://support.broadcastradio.com/products/BootStuff/v1/v1.2.1/BRBootStuff1.msi