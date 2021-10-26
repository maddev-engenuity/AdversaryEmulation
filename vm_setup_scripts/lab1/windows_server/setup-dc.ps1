#We want to stop the setup process on any error, as that suggests a breaking condition
$ErrorActionPreference = "Stop"

#Step 0
#Copy scripts to C:\Users\Public if they're not already there
if (-not (Test-Path C:\Users\Public\setup-dc.ps1) -or -not (Test-Path C:\Users\Public\set-windows-wallpaper.ps1) -or -not (Test-Path C:\Users\Public\Pictures\target_background.png)) {
    Write-Host "[i] Copying scripts to C:\Users\Public"
    Copy-Item .\setup-dc.ps1,.\disable-defender.ps1,.\rename-dc.ps1,.\create-domain.ps1,.\add-domain-entities.ps1,.\download-tools.ps1,.\set-windows-wallpaper.ps1 -Destination C:\Users\Public;
    Copy-Item .\target-background.png -Destination C:\Users\Public\Pictures\target_background.png;
}

#Step 1
if ($env:COMPUTERNAME -ne "DC01") {
    #Disable defender, add setup script to registry run key, and rename computer.
    powershell -ep bypass C:\Users\Public\disable-defender.ps1;

    #Setting up autologon to make setup process simpler and easier for students
    Write-Host "[i] If you wish to avoid having to manually login each time the server reboots during the setup process, please provide your password here. Otherwise, simply leave blank and hit enter."
    $password = Read-Host "Login Password"
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultUserName' -Type String -Value "Administrator";
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultPassword' -Type String -Value $password;
    New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'AutoAdminLogon' -Type String -Value "1";

    Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name 'SetupDC' -Value "C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -ep bypass C:\Users\Public\setup-dc.ps1"
    Write-Host "[i] Set registry Run key for this script. Script will automatically complete with intermittent reboots"
    Start-Sleep -Seconds 3
    powershell -ep bypass C:\Users\Public\rename-dc.ps1;
} 
#Step 2
elseif ((Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem).Domain -ne "MAD.local") {
    #Add domain name to auto login
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultDomainName' -Type String -Value "MAD";

    #Create MAD.local domain. Server will restart after domain is created
    powershell -ep bypass C:\Users\Public\create-domain.ps1;
}
#Step 3
else {
    #Add domain entities (computer accounts, organizational units, and user accounts)
    powershell -ep bypass C:\Users\Public\add-domain-entities.ps1;

    #Download needed tools for emulation procedure
    powershell -ep bypass C:\Users\Public\download-tools.ps1;

    #Set Windows wallpaper
    powershell -ep bypass C:\Users\Public\set-windows-wallpaper.ps1

    #Remove setup script from registry Run key
    Remove-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name 'SetupDC'
    Write-Host "[i] Registry Run key for this script removed."

    #Remove Autologon creds
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultUserName' -Type String -Value "";
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultPassword' -Type String -Value "";
    Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'AutoAdminLogon';
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultDomainName' -Type String -Value "";
    Write-Host "[i] Removed autologon credentials."

    Write-Host "[i] Setup is now complete. Server will reboot for clean start."
    Start-Sleep -Seconds 3
    Restart-Computer -Force
}
