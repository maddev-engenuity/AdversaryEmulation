#Download adfind to Windows directory
$postParams = @{B1='Download+Now';download="AdFind.zip";email=''};
Invoke-WebRequest -Uri http://www.joeware.net/downloads/dl.php -Method POST -Body $postParams -OutFile C:\Users\Public\adfind.zip;
Expand-Archive -Path C:\Users\Public\adfind.zip -DestinationPath C:\Users\Public -Force;
Move-Item -Path C:\Users\Public\AdFind.exe -Destination C:\Windows\AdFind.exe -Force;
Remove-Item -Path C:\Users\Public\adfind.zip -Force;
Remove-Item -Path C:\Users\Public\adcsv.pl -Force;
Write-Host "[+] Downloaded AdFind to Windows directory"

#Download plink to Windows directory
try {
    Invoke-WebRequest -Uri https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe -OutFile C:\Windows\plink.exe;
} catch {
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
    Invoke-WebRequest -Uri https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe -OutFile C:\Windows\plink.exe;

}
Write-Host "[+] Downloaded plink to Windows directory";

#Copy 7za to Windows directory
Copy-Item -Path ..\..\..\external\7zip-extra\7za.exe -Destination C:\Windows\7za.exe -Force;
Write-Host "[i] Copied 7za to Windows directory";

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