Disable-GameBarTips
Disable-MicrosoftUpdate
Disable-UAC
Disable-BingSearch
Enable-RemoteDesktop
Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart
Set-ExplorerOptions -showFileExtensions -showHiddenFilesFoldersDrives -showProtectedOSFiles
cinst aria2 -y
cinst ccleaner -y

# FFMpeg is 64bit only in choco
if([System.Environment]::Is64BitOperatingSystem){
    cinst ffmpeg -y
}