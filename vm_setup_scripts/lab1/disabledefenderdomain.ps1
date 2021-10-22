New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
New-GPO -Name "Disable Windows Defender" -Comment "Disables Windows Defender for the Domain"
Set-GPRegistryValue -Name "Disable Windows Defender" -Key "HKCU\Software\Policies\Microsoft\Windows Defender" -ValueName DisableAntiSpyware -Type REG_DWORD -Value 1
New-GPLink -Name "Disable Windows Defender" -Target "dc=FINANCIAL,dc=local"