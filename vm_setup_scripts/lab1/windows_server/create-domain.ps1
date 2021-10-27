#Create MAD.local domain
Write-Host "[i] Creating MAD.local domain"
Install-WindowsFeature AD-Domain-Services
Import-Module ADDSDeployment
$SecPassword = ConvertTo-SecureString "j4yqN3EYcL_KQ?L2" -AsPlainText -Force
#needs to restart after the install-ADDSForest command to actually come back up as a DC
Write-Host "[i] The server will automatically restart after the domain is created"
Install-ADDSForest -CreateDnsDelegation:$false -DomainName "MAD.local" -DomainNetbiosName "MAD" -InstallDns:$true -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -ForestMode "7" -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword $SecPassword
