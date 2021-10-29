Add-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory

#Creating workstations in the form of Computer Accounts
Write-Host "[i] Adding workstations (computer accounts) to domain"
New-ADComputer -Name "WKST01" -AccountPassword (ConvertTo-SecureString 'wk1Passw0rd!' -AsPlainText -Force)
New-ADComputer -Name "WKST02" -AccountPassword (ConvertTo-SecureString 'wk2Passw0rd!' -AsPlainText -Force)
New-ADComputer -Name "WKST03" -AccountPassword (ConvertTo-SecureString 'wk3Passw0rd!' -AsPlainText -Force)
Write-Host "[+] WKST01, WKST02, and WKST03 computer accounts added to MAD.local"

#Creating Organizational Units
Write-Host "[i] Adding Organizational Units to domain"
New-ADOrganizationalUnit -Name "Managers" -Path "DC=MAD,DC=local"
New-ADOrganizationalUnit -Name "HR" -Path "DC=MAD,DC=local"
New-ADOrganizationalUnit -Name "UserAccounts" -Path "DC=MAD,DC=local"
Write-Host "[+] Managers, HR, and UserAccounts Organizational Units added to MAD.local"

#Creating Users
Write-Host "[i] Adding regular users to domain"
New-ADUser -Name "Jeniffer Tarantino" -GivenName "Jennifer" -Surname "Tarantino" -SamAccountName "jtarantino" -UserPrincipalName "jtarantino@MAD.local" -Path "OU=Managers,DC=MAD,DC=local" -AccountPassword (ConvertTo-SecureString "jtPassw0rd!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Donald Dougherty" -GivenName "Donald" -Surname "Dougherty" -SamAccountName "ddougherty" -UserPrincipalName "ddougherty@MAD.local" -Path "OU=HR,DC=MAD,DC=local" -AccountPassword (ConvertTo-SecureString "ddPassw0rd!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Evelyn Gismond" -GivenName "Evelyn" -Surname "Gismond" -SamAccountName "egismond" -UserPrincipalName "egismond@MAD.local" -Path "OU=UserAccounts,DC=MAD,DC=local" -AccountPassword (ConvertTo-SecureString "egPassw0rd!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Shanon Blue" -GivenName "Shanon" -Surname "Blue" -SamAccountName "sblue" -UserPrincipalName "sblue@MAD.local" -Path "OU=UserAccounts,DC=MAD,DC=local" -AccountPassword (ConvertTo-SecureString "sbPassw0rd!" -AsPlainText -Force) -Enabled $true

Write-Host "[+] jtarantino, ddougherty, egismond, and sblue user accounts added to MAD.local"

#Easing password policy requirements
Set-ADDefaultDomainPasswordPolicy -Identity MAD.local -ComplexityEnabled $false -MinPasswordLength 1 -PasswordHistoryCount 1

#Adding new Domain Admin account
Write-Host "[i] Adding madAdmin Domain Admin account"
New-ADUser -Name "madAdmin" -AccountPassword (ConvertTo-SecureString 'ATT&CK' -AsPlainText -Force) -Enabled $true
Add-ADGroupMember -Identity "Domain Admins" -Members "madAdmin"
net localgroup Administrators madAdmin /add
Write-Host "[i] madAdmin Domain Admin account added"