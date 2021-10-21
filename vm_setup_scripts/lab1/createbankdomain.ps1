Install-WindowsFeature AD-Domain-Services
Import-Module ADDSDeployment
$SecPassword = ConvertTo-SecureString "j4yqN3EYcL_KQ?L2" -AsPlainText -Force
#needs to restart after the install-ADDSForest command to actually come back up as a DC
Install-ADDSForest -CreateDnsDelegation:$false -DomainName "financial.local" -DomainNetbiosName "FINANCIAL" -InstallDns:$true -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -ForestMode "7" -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword $SecPassword
