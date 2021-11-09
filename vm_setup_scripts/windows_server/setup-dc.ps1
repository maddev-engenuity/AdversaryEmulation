#We want to stop the setup process on any error, as that suggests a breaking condition
$ErrorActionPreference = "Stop"

#Step 0
#Copy scripts to C:\Users\Public if they're not already there
if (-not (Test-Path C:\Users\Public\setup-dc.ps1) -or -not (Test-Path C:\Users\Public\set-windows-wallpaper.ps1) -or -not (Test-Path C:\Users\Public\Pictures\target-background.png)) {
    Write-Host "[i] Copying scripts to C:\Users\Public";
    Copy-Item .\setup-dc.ps1,.\SetupDC.xml,.\disable-defender.ps1,.\rename-dc.ps1,.\create-domain.ps1,.\add-domain-entities.ps1,.\install-tools.ps1,.\hidden-files.ps1,.\set-windows-wallpaper.ps1 -Destination C:\Users\Public;
    Copy-Item .\target-background.png -Destination C:\Users\Public\Pictures\target-background.png;
}

#Step 1
if ($env:COMPUTERNAME -ne "targetDC") {
    #Disable defender, add setup script to registry run key, and rename computer.
    powershell -ep bypass C:\Users\Public\disable-defender.ps1;
    #Setting up autologon to make setup process simpler and easier for students
    Write-Host "[i] If you wish to avoid having to manually login each time the server reboots during the setup process, please provide the Administrator user password that you configured here. Otherwise, simply leave blank and hit enter.";
    $password = Read-Host "Login Password";
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultUserName' -Type String -Value "Administrator";
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultPassword' -Type String -Value $password;
    New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'AutoAdminLogon' -Type String -Value "1";

    #Replace username and userID placeholders in Scheduled Task XML file with local values
    $sid = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value;
    ((Get-Content -Path C:\Users\Public\SetupDC.xml -Raw) -Replace '{WHOAMI}',(whoami)) -Replace '{SID}',$sid | Set-Content -Path C:\Users\Public\SetupDC.xml;
    #Then use XML file to create Scheduled Task to continue setup process after reboots
    Register-ScheduledTask -TaskName 'SetupDC' -XML (Get-Content -Path C:\Users\Public\SetupDC.xml | Out-String);
    Write-Host "[i] Scheduled Task SetupDC to continue setup as Administrator set";

    #Install Emulation and Detection tools
    Write-Host "[i] Installing emulation and detection tools"
    powershell -ep bypass C:\Users\Public\install-tools.ps1;

    Start-Sleep -Seconds 3;
    powershell -ep bypass C:\Users\Public\rename-dc.ps1;
} 
#Step 2
elseif ((Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem).Domain -ne "MAD.local") {
    #Add domain name to auto login
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultDomainName' -Type String -Value "MAD";

    #Create MAD.local domain. Server will restart after domain is created
    powershell -ep bypass C:\Users\Public\create-domain.ps1;
}
else {
    #Step 3
    #Waiting for AD services to start up after server restart. If AD services are not up, Get-ADUser should error out
    Write-Host "[i] Waiting for AD services to start"
    $AD_enabled = $false;
    while (-not ($AD_enabled)) {
        try {
            Get-ADUser Administrator;
            $AD_enabled = $true;
            Write-Host "[+] AD Services started, proceeding"
        } catch {
            Write-Host "[i] Still waiting..."
            Start-Sleep -Seconds 5;
        }
    }
    
    #We need to add the new domain user and configure things under their account, so we start by checking if that account exists
    $userobj = $(try {Get-ADUser "madAdmin"} catch {$Null});
    if ($userobj -eq $Null) {
        #Add domain entities (computer accounts, organizational units, and user accounts)
        powershell -ep bypass C:\Users\Public\add-domain-entities.ps1;

        #Modify scheduled task to complete as madAdmin user in elevated context
        $trigger = New-ScheduledTaskTrigger -AtLogon -User 'madAdmin';
        Set-ScheduledTask -TaskName 'SetupDC' -User 'madAdmin' -Trigger $trigger;
        Write-Host "[i] Modified SetupDC scheduled task to complete as madAdmin";

        #Changing autologon credentials to new user
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultUserName' -Type String -Value "madAdmin";
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultPassword' -Type String -Value "ATT&CK";
        Write-Host "[i] Changed autologon creds to MAD\madAdmin";

        Start-Sleep -Seconds 3;
        Restart-Computer -Force;
    }
    #Step 4
    else {
        #Make hidden files and extensions visible in Explorer
        Write-Host "[i] Making hidden files and extensions visible in Explorer"
        powershell -ep bypass C:\Users\Public\hidden-files.ps1;

        #Set Windows wallpaper
        Write-Host "[i] Setting desktop background"
        powershell -ep bypass C:\Users\Public\set-windows-wallpaper.ps1;

        #Enable wdigest cleartext password logging
        Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest' -Name 'UseLogonCredential' -Type DWord -Value 1;

        #Allow FTP connections through the FireWall
        New-NetFirewallRule -DisplayName "FTP In" -Direction Inbound -Protocol TCP -Enabled True -Action Allow -Profile Any -Program "%SystemRoot%\System32\ftp.exe" -Service Any -LocalPort 20,21,1024-65535 -EdgeTraversalPolicy Allow;
        
        #Remove SetupDC scheduled task
        Unregister-ScheduledTask -TaskName 'SetupDC' -Confirm:$false;
        Write-Host "[i] Deleted SetupDC scheduled task";

        #Remove Autologon creds
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultUserName' -Type String -Value "";
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultPassword' -Type String -Value "";
        Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'AutoAdminLogon';
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name 'DefaultDomainName' -Type String -Value "";
        Write-Host "[i] Removed autologon credentials.";

        Write-Host "[i] Setup is now complete. Server will reboot for clean start.";
        Start-Sleep -Seconds 3;
        Restart-Computer -Force;
    }
}
