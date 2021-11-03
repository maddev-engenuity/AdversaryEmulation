#Install Chocolatey if it is not already installed, and then install sysinternals, apimonitor, and wireshark
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

choco install sysinternals apimonitor wireshark -y;
Write-Host "[+] Installed sysinternals, apimonitor, and wireshark";