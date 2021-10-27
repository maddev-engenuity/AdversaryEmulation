#Rename Computer, takes effect on restart
Write-Host "[i] Renaming server to targetDC"
Write-Host "[i] Server will automatically restart"
Rename-Computer -NewName "targetDC" -Restart
