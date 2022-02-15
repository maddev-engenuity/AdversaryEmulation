#Install Chocolatey if it is not already installed
$testchoco = $false;
try { choco -v; $testchoco = $true } catch { $testchoco = $false };
if (-not $testchoco) {
    try {
        Write-Host "[i] Chocolatey not already installed, installing now";
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'));
        Write-Host "[+] Installed Chocolatey";
    } catch {
        Write-Host "[-] Failed to install Chocolatey";
        Write-Host "[-] It looks like your VM may be behind a proxy causing SSL Certificate errors. To run this script, either connect to the internet without the proxy, or install the proxy's certificates on your VM. Once that's done, you can rerun this script.";
        Return;
    }
} else {
    Write-Host "[+] Chocolatey already installed, proceeding";
}

#Install Microsoft Office with Chocolatey
choco install office365business --params='/exclude:"Access Groove Lync OneDrive OneNote Outlook Publisher Excel PowerPoint Teams"' -y;
Write-Host "[+] Installed Microsoft Office";

#Install 7-Zip Command Line tools with Chocolatey
choco install 7zip.install -y;
Move-Item -Path C:\ProgramData\chocolatey\bin\7z.exe -Destination C:\ProgramData\chocolatey\bin\7.exe;
Write-Host "[+] Installed 7-Zip";

#Install PuTTY Portable Suite for Plink.exe with Chocolatey
choco install putty.portable -y;
Write-Host "[+] Installed PuTTY Suite (Plink.exe)";

#Download AdFind to Windows directory
$postParams = @{B1='Download+Now';download="AdFind.zip";email=''};
Invoke-WebRequest -Uri http://www.joeware.net/downloads/dl2.php -Method POST -Body $postParams -OutFile C:\Users\Public\adfind.zip;
Expand-Archive -Path C:\Users\Public\adfind.zip -DestinationPath C:\Users\Public -Force;
Move-Item -Path C:\Users\Public\AdFind.exe -Destination C:\Windows\AdFind.exe -Force;
Remove-Item -Path C:\Users\Public\adfind.zip -Force;
Remove-Item -Path C:\Users\Public\adcsv.pl -Force;
Write-Host "[+] Downloaded AdFind to Windows directory";

#Download WCE to Windows directory
Invoke-WebRequest -Uri https://www.ampliasecurity.com/research/wce_v1_42beta_x64.zip -OutFile C:\Users\Public\wce.zip;
Expand-Archive -Path C:\Users\Public\wce.zip -DestinationPath C:\Users\Public\wce -Force;
Move-Item -Path C:\Users\Public\wce\wce.exe -Destination C:\Windows\wce.exe -Force;
Remove-Item C:\Users\Public\wce.zip -Force;
Remove-Item -Recurse -Force C:\Users\Public\wce;
Write-Host "[i] Downloaded WCE to Windows directory";

#Download PowerSploit
Invoke-WebRequest -Uri https://github.com/PowerShellMafia/PowerSploit/archive/refs/heads/master.zip -OutFile C:\Users\Public\PowerSploit.zip
Expand-Archive -Path C:\Users\Public\PowerSploit.zip -DestinationPath C:\Users\Public\ -Force;
Remove-Item C:\Users\Public\PowerSploit.zip -Force;
Move-Item -Path C:\Users\Public\PowerSploit-master -Destination C:\Users\Public\PowerSploit -Force;
Write-Host "[i] Downloaded PowerSploit to C:\Users\Public";

#Install SysInternals using Chocolatey
choco install sysinternals -y;
Write-Host "[+] Installed SysInternals";

#Install APIMonitor using Chocolatey
choco install apimonitor -y;
Write-Host "[+] Installed APIMonitor";

#Install WireShark using Chocolatey
choco install wireshark -y;
Write-Host "[+] Installed WireShark";
