Add-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory

New-ADUser -Name "Jeniffer Tarantino" -GivenName "Jennifer" -Surname "Tarantino" -SamAccountName "jtarantino" -UserPrincipalName "jtarantino@FINANCIAL.local" -Path "CN=Users,DC=FINANCIAL,DC=local" -AccountPassword (ConvertTo-SecureString "jtPassw0rd!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Donald Dougherty" -GivenName "Donald" -Surname "Dougherty" -SamAccountName "ddougherty" -UserPrincipalName "ddougherty@FINANCIAL.local" -Path "CN=Users,DC=FINANCIAL,DC=local" -AccountPassword (ConvertTo-SecureString "ddPassw0rd!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Evelyn Gismond" -GivenName "Evelyn" -Surname "Gismond" -SamAccountName "egismond" -UserPrincipalName "egismond@FINANCIAL.local" -Path "CN=Users,DC=FINANCIAL,DC=local" -AccountPassword (ConvertTo-SecureString "egPassw0rd!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Shanon Blue" -GivenName "Shanon" -Surname "Blue" -SamAccountName "sblue" -UserPrincipalName "sblue@FINANCIAL.local" -Path "CN=Users,DC=FINANCIAL,DC=local" -AccountPassword (ConvertTo-SecureString "sbPassw0rd!" -AsPlainText -Force) -Enabled $true