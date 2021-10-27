# If Chocolatey package manager is not installed already, install
if (-not (powershell choco -v)) {
    Write-Host "[*] Installing Chocolatey package manager"
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    try {
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
    } catch {
        # [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} ;
        add-type @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@;
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy;
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
    }
}

# install needed tools
Write-Host "[*] Installing needed tools"
try {
    choco install sysinternals apimonitor wireshark -y
} catch {
    Write-Host "[-] It looks like your VM is behind a proxy causing SSL Certificate errors. To run this script, either connect to the internet without the proxy, or install the proxy's certificates on your VM. Once that's done, you can either rerun this script, or simply run the following command: "
    Write-Host "[i] choco install sysinternals apimonitor wireshark -y"
}