#Setting static IP within current CIDR range
$adapter = Get-NetAdapter | ? {$_.Name -eq "Ethernet"}
$currIP = ($adapter | Get-NetIPAddress -AddressFamily IPv4).IPAddress
$staticIP = ($currIP.Split(".")[0..2] + 50) -join "."

If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
 $adapter | Remove-NetIPAddress -AddressFamily IPv4 -Confirm:$false
}
If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
 $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
}

$adapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $staticIP -PrefixLength 24

Install-WindowsFeature AD-Domain-Services
Import-Module ADDSDeployment
$SecPassword = ConvertTo-SecureString "j4yqN3EYcL_KQ?L2" -AsPlainText -Force
#needs to restart after the install-ADDSForest command to actually come back up as a DC
Install-ADDSForest -CreateDnsDelegation:$false -DomainName "financial.local" -DomainNetbiosName "FINANCIAL" -InstallDns:$true -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -ForestMode "7" -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword $SecPassword
