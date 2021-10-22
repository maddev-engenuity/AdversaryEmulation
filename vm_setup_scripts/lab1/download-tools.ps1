#Download adfind
$postParams = @{B1='Download+Now';download="AdFind.zip";email=''};
Invoke-WebRequest -Uri http://www.joeware.net/downloads/dl.php -Method POST -Body $postParams -OutFile C:\Users\Public\adfind.zip;
Expand-Archive -Path C:\Users\Public\adfind.zip -DestinationPath C:\Users\Public;
Remove-Item -Path C:\Users\Public\adfind.zip;
Remove-Item -Path C:\Users\Public\adcsv.pl;
Write-Host "[+] Downloaded AdFind.exe"

#Download plink
Invoke-WebRequest -Uri https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe -OutFile C:\Users\Public\plink.exe;
Write-Host "[+} Downloaded plink.exe"
