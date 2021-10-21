Add-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory
New-ADComputer -Name "Wkst1" -AccountPassword (ConvertTo-SecureString 'wk1Passw0rd!' -AsPlainText -Force)
New-ADComputer -Name "Wkst2" -AccountPassword (ConvertTo-SecureString 'wk2Passw0rd!' -AsPlainText -Force)
New-ADComputer -Name "Wkst3" -AccountPassword (ConvertTo-SecureString 'wk3Passw0rd!' -AsPlainText -Force)