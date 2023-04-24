#Author: Christian Galvan
#Description: Disable windows defender, cloudbased protectection and all AV protections for the purpose of Adversary Operations Course on Windows Server 2019 Fullbase in AWS
#Check AV definition updates Source: https://theitbros.com/managing-windows-defender-using-powershell/

Get-MpComputerStatus | Select-Object -Property Antivirusenabled,AMServiceEnabled,AntispywareEnabled,BehaviorMonitorEnabled,IoavProtectionEnabled,NISEnabled,OnAccessProtectionEnabled,RealTimeProtectionEnabled,IsTamperProtected,AntivirusSignatureLastUpdated

Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -MAPSReporting 0
#get status on tamper protection​
Get-MpComputerStatus | select IsTamperProtected
#disable Microsoft Defender real-time protection with PowerShell
Set-MpPreference -DisableRealtimeMonitoring $true
#stop the real-time protection and run the following command in the elevated PowerShell session
Uninstall-WindowsFeature -Name Windows-Defender
#You can disable archive files scanning using the command:
Set-MpPreference -DisableArchiveScanning $True
#check status of archive scanning
Get-MpPreference|select DisableArchiveScanning
#disable cloud based protection
Set-MpPreference -MAPSReporting 0
​

#check all security definitions again
Get-MpComputerStatus | Select-Object -Property Antivirusenabled,AMServiceEnabled,AntispywareEnabled,BehaviorMonitorEnabled,IoavProtectionEnabled,NISEnabled,OnAccessProtectionEnabled,RealTimeProtectionEnabled,IsTamperProtected,AntivirusSignatureLastUpdated

#remove active threat using microsoft defender
Defender\Remove-MpThreat

Write-Host "Restart your server in order to remove all virus protection for this course" -ForegroundColor Green
Write-Host "You can use the shutdown /r command to do it via CMD" -ForegroundColor Green
