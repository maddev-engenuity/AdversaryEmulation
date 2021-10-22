#Rename Computer, takes effect on restart
Write-Host "[i] Renaming server to DC01"
Write-Host "[i] Server will automatically restart"
Rename-Computer -NewName "DC01" -Restart