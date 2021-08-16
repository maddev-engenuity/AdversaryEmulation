# This script configures the target Windows VM used in MITRE ATT&CK Defender's
# ATT&CK(R) Adversary Emulation course.
# Download and install a Windows 10 VM, then run this script on the VM.
#
# To execute this script:
#   1) Open powershell.exe as administrator
#   2) Allow script execution by running the command: "Set-ExecutionPolicy Unrestricted -Force"
#   3) Execute the script by running ".\setup_windows_target.ps1"
#   4) Reboot the VM when complete.
#
# [Important]
#    Windows Defender should be fully disabled on this VM.
#    Our script attempts to disable Windows Defender; however,
#    the script will fail if Tamper Protection is enabled.
#    Tamper Protection must first be disabled using the GUI.

# check if we're admin
$RunningAsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if ($RunningAsAdmin -eq $FALSE) {
    Write-Host "You must run this script as administrator."
    return
}

# Disable Windows Defender
Write-Host "[*] Disabling Windows Defender"
.\disable_defender.ps1

# Disable Smart Screen
Write-Host "[*] Disabling Smart Screen"
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force

# Disable firewall
Write-Host "[*] Disabling firewall"
netsh advfirewall set allprofiles state off

# Disable Cortana
Write-Host "[*] Disabling Cortana"
$Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
$Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
$Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
If (!(Test-Path $Cortana1)) {
    New-Item $Cortana1
}
Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 0 
If (!(Test-Path $Cortana2)) {
    New-Item $Cortana2
}
Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 1 
Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 1 
If (!(Test-Path $Cortana3)) {
    New-Item $Cortana3
}
Set-ItemProperty $Cortana3 HarvestContacts -Value 0

# Disable Telemetry

# Disables Windows Feedback Experience
Write-Output "[*] Disabling Windows Feedback Experience program"
$Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
If (Test-Path $Advertising) {
    Set-ItemProperty $Advertising Enabled -Value 0 
}
        
# Stops Cortana from being used as part of your Windows Search Function
Write-Output "[*] Stopping Cortana from being used as part of your Windows Search Function"
$Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
If (Test-Path $Search) {
    Set-ItemProperty $Search AllowCortana -Value 0 
}

# Disables Web Search in Start Menu
Write-Output "[*] Disabling Bing Search in Start Menu"
$WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0 
If (!(Test-Path $WebSearch)) {
    New-Item $WebSearch
}
Set-ItemProperty $WebSearch DisableWebSearch -Value 1 
        
# Prevents bloatware applications from returning and removes Start Menu suggestions               
Write-Output "[*] Adding Registry key to prevent bloatware apps from returning"
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$registryOEM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
If (!(Test-Path $registryPath)) { 
    New-Item $registryPath
}
Set-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1 

If (!(Test-Path $registryOEM)) {
    New-Item $registryOEM
}
Set-ItemProperty $registryOEM  ContentDeliveryAllowed -Value 0 
Set-ItemProperty $registryOEM  OemPreInstalledAppsEnabled -Value 0 
Set-ItemProperty $registryOEM  PreInstalledAppsEnabled -Value 0 
Set-ItemProperty $registryOEM  PreInstalledAppsEverEnabled -Value 0 
Set-ItemProperty $registryOEM  SilentInstalledAppsEnabled -Value 0 
Set-ItemProperty $registryOEM  SystemPaneSuggestionsEnabled -Value 0          

# Preping mixed Reality Portal for removal    
Write-Output "[*] Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings"
$Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"    
If (Test-Path $Holo) {
    Set-ItemProperty $Holo  FirstRunSucceeded -Value 0 
}

# Disables Wi-fi Sense
Write-Output "[*] Disabling Wi-Fi Sense"
$WifiSense1 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"
$WifiSense2 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"
$WifiSense3 = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
If (!(Test-Path $WifiSense1)) {
    New-Item $WifiSense1
}
Set-ItemProperty $WifiSense1  Value -Value 0 
If (!(Test-Path $WifiSense2)) {
    New-Item $WifiSense2
}
Set-ItemProperty $WifiSense2  Value -Value 0 
Set-ItemProperty $WifiSense3  AutoConnectAllowedOEM -Value 0 
    
# Disables live tiles
Write-Output "[*] Disabling live tiles"
$Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"    
If (!(Test-Path $Live)) {      
    New-Item $Live
}
Set-ItemProperty $Live  NoTileApplicationNotification -Value 1 
    
# Turns off Data Collection via the AllowTelemtry key by changing it to 0
Write-Output "[*] Turning off Data Collection"
$DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
$DataCollection2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$DataCollection3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"    
If (Test-Path $DataCollection1) {
    Set-ItemProperty $DataCollection1  AllowTelemetry -Value 0 
}
If (Test-Path $DataCollection2) {
    Set-ItemProperty $DataCollection2  AllowTelemetry -Value 0 
}
If (Test-Path $DataCollection3) {
    Set-ItemProperty $DataCollection3  AllowTelemetry -Value 0 
}

# Disabling Location Tracking
Write-Output "[*] Disabling Location Tracking"
$SensorState = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
$LocationConfig = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
If (!(Test-Path $SensorState)) {
    New-Item $SensorState
}
Set-ItemProperty $SensorState SensorPermissionState -Value 0 
If (!(Test-Path $LocationConfig)) {
    New-Item $LocationConfig
}
Set-ItemProperty $LocationConfig Status -Value 0 
    
# Disables People icon on Taskbar
Write-Output "[*] Disabling People icon on Taskbar"
$People = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People"    
If (!(Test-Path $People)) {
    New-Item $People
}
Set-ItemProperty $People  PeopleBand -Value 0 
    
# Disables scheduled tasks that are considered unnecessary 
Write-Output "[*] Disabling scheduled tasks"
Get-ScheduledTask  XblGameSaveTask | Disable-ScheduledTask
Get-ScheduledTask  Consolidator | Disable-ScheduledTask
Get-ScheduledTask  UsbCeip | Disable-ScheduledTask
Get-ScheduledTask  DmClient | Disable-ScheduledTask
Get-ScheduledTask  DmClientOnScenarioDownload | Disable-ScheduledTask

# Stop and disable WAP Push Service
Write-Output "[*] Stopping and disabling WAP Push Service"
Stop-Service "dmwappushservice"
Set-Service "dmwappushservice" -StartupType Disabled

# Disabling the Diagnostics Tracking Service
Write-Output "[*] Stopping and disabling Diagnostics Tracking Service"
Stop-Service "DiagTrack"
Set-Service "DiagTrack" -StartupType Disabled

# add the 'target' user
# Write-Host "[*] Adding user: 'target'"
# net user /add target "ATT&CK"
# net user target /EXPIRES:NEVER
# net localgroup /ADD Administrators target

# set desktop background
Write-Host "[*] Setting desktop background"
.\set_windows_wallpaper.ps1

# Enable RDP
Write-Host "[*] Enabling RDP"
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /d 0 /t REG_DWORD /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "UserAuthentication" /d 0 /t REG_DWORD /f

# Install package manager
Write-Host "[*] Installing Chocolatey package manager"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# install needed tools
Write-Host "[*] Installing needed tools"
choco install sysinternals apimonitor wireshark -y

# set VM hostname
$hostname = hostname
if ($hostname -ne "targetVM"){
  Write-Host "[*] Renaming hostname to 'targetVM'"
  Rename-Computer -NewName "targetVM"
}

# View file extensions and hidden items
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key HideFileExt 0
Set-ItemProperty $key ShowSuperHidden 1
Stop-Process -processname explorer

# Reboot
Write-Host "[*] Setup complete."
Write-Host "[*] Please reboot the system and log back in."
Write-Host "[*] Make sure Windows Defender is still disabled after reboot."
Write-Host "[*] If Defender is still on, make sure Tamper Protection is disabled, then re-run 'disable_defender.ps1' and reboot."
#$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
#Restart-Computer -Force