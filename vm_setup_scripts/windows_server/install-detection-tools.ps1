#Install Chocolatey package manager, and then install sysinternals, apimonitor, and wireshark
Write-Host "[*] Installing Chocolatey package manager"
Set-ExecutionPolicy Bypass -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
try {
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
    choco install sysinternals apimonitor wireshark -y;
} catch {
    Write-Host "[-] It looks like your VM may be behind a proxy causing SSL Certificate errors. To run this script, either connect to the internet without the proxy, or install the proxy's certificates on your VM. Once that's done, you can rerun this script."
}
