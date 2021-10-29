#!/bin/bash
exe_directory="/home/attacker/fin6-windows-tools"

#Create directory to store executables, as well as temporary directory to download files
mkdir -p $exe_directory/downloads/

#Download adfind.exe
curl http://www.joeware.net/downloads/dl.php -X POST -d "B1=Download+Now&download=AdFind.zip&email=" -o $exe_directory/downloads/adfind.zip
unzip $exe_directory/downloads/adfind.zip -d $exe_directory/downloads/
mv $exe_directory/downloads/AdFind.exe $exe_directory/

#Download plink.exe
wget https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe -P $exe_directory/

#download 7zip.exe
wget https://www.7-zip.org/a/7z1900-x64.exe -P $exe_directory/downloads/
mv $exe_directory/downloads/7z*.exe $exe_directory/7zip.exe

#Download wce.exe
wget https://www.ampliasecurity.com/research/wce_v1_42beta_x64.zip -P $exe_directory/downloads/
unzip $exe_directory/downloads/wce_v1_42beta_x64.zip -d $exe_directory/downloads/
mv $exe_directory/downloads/wce.exe $exe_directory/

#Download PowerSploit
git clone https://github.com/PowerShellMafia/PowerSploit.git $exe_directory/PowerSploit

#Delete temporary download location
rm -rf $exe_directory/downloads

echo "adfind.exe, 7zip.exe, wce.exe, and PowerSploit downloaded to $exe_directory"