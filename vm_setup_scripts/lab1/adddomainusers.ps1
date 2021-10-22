Add-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory


New-ADOrganizationalUnit -Name "Managers" -Path "DC=FINANCIAL,DC=local"
New-ADOrganizationalUnit -Name "HR" -Path "DC=FINANCIAL,DC=local"
New-ADOrganizationalUnit -Name "UserAccounts" -Path "DC=FINANCIAL,DC=local"

New-ADUser -Name "Jeniffer Tarantino" -GivenName "Jennifer" -Surname "Tarantino" -SamAccountName "jtarantino" -UserPrincipalName "jtarantino@FINANCIAL.local" -Path "OU=Managers,DC=FINANCIAL,DC=local" -AccountPassword (ConvertTo-SecureString "jtPassw0rd!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Donald Dougherty" -GivenName "Donald" -Surname "Dougherty" -SamAccountName "ddougherty" -UserPrincipalName "ddougherty@FINANCIAL.local" -Path "OU=HR,DC=FINANCIAL,DC=local" -AccountPassword (ConvertTo-SecureString "ddPassw0rd!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Evelyn Gismond" -GivenName "Evelyn" -Surname "Gismond" -SamAccountName "egismond" -UserPrincipalName "egismond@FINANCIAL.local" -Path "OU=UserAccounts,DC=FINANCIAL,DC=local" -AccountPassword (ConvertTo-SecureString "egPassw0rd!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Shanon Blue" -GivenName "Shanon" -Surname "Blue" -SamAccountName "sblue" -UserPrincipalName "sblue@FINANCIAL.local" -Path "OU=UserAccounts,DC=FINANCIAL,DC=local" -AccountPassword (ConvertTo-SecureString "sbPassw0rd!" -AsPlainText -Force) -Enabled $true