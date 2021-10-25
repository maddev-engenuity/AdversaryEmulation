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

# add the 'target' user
# Write-Host "[*] Adding user: 'target'"
# net user /add target "ATT&CK"
# net user target /EXPIRES:NEVER
# net localgroup /ADD Administrators target

# set desktop background
Write-Host "[*] Setting desktop background"
.\set_windows_wallpaper.ps1

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
