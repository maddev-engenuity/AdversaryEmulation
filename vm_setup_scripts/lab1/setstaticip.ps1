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
