#We want to stop the setup process on any error, as that suggests a breaking condition
$ErrorActionPreference = "Stop"

#Step 1
if ($env:COMPUTERNAME -ne "DC01") {
    #Disable defender, add setup script to registry run key, and rename computer.
    powershell -ep bypass C:\Users\Administrator\AdversaryEmulation\vm_setup_scripts\lab1\disable-defender.ps1;

    Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name 'SetupDC' -Value "C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -ep bypass C:\Users\Administrator\AdversaryEmulation\vm-setup-scripts\lab1\setup-dc.ps1"
    Write-Host "[i] Set registry Run key for this script. Script will automatically complete with intermittent reboots"

    powershell -ep bypass C:\Users\Administrator\AdversaryEmulation\vm_setup_scripts\lab1\rename-dc.ps1;
} 
#Step 2
elseif ((Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem).Domain -ne "MAD.local") {
    #Create MAD.local domain. Server will restart after domain is created
    powershell -ep bypass C:\Users\Administrator\AdversaryEmulation\vm_setup_scripts\lab1\create-domain.ps1;
}
#Step 3
else {
    #Add domain entities (computer accounts, organizational units, and user accounts)
    powershell -ep bypass C:\Users\Administrator\AdversaryEmulation\vm_setup_scripts\lab1\add-domain-entities.ps1;

    #Download needed tools for emulation procedure
    powershell -ep bypass C:\Users\Administrator\AdversaryEmulation\vm_setup_scripts\lab1\download-tools.ps1;

    #Remove setup script from registry Run key
    Remove-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name 'SetupDC'
    Write-Host "[i] Registry Run key for this script removed. Setup is now complete. Server will reboot for clean start."
}




