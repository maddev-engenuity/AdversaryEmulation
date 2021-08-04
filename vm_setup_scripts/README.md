# MAD ATT&CK Adversary Emulation VM Setup Instructions

Remarks

## Configure Windows Target

1. Install a Windows VM with the following settings:

```
OS: Latest version of Windows 10
CPU: 2 core CPU
RAM: 8 GB
Disk: 50 GB
Networking: Should be able to ping the Kali attack platform and reach the Internet
```

2. During OS installation, configure the hostname and username:

```
Hostname: targetVM
Username: target
Password: ATT&CK
```

3. Decline all telemetry / Microsoft account prompts.

4. After the OS has installed, login as target, open Windows Defender settings and disable all features:

```
Real Time Protection
Cloud Based Protection
Automatic Sample Submission
Tamper Protection
```

5. Open an administrative PowerShell terminal and run the setup script as follows:

```powershell
Set-ExecutionPolicy Bypass -Force
.\setup_windows_target.ps1
```

6. Reboot the VM, log back in, and confirm Windows Defender is still disabled.

If Defender is still enabled, open Defender settings, disable all features, re-run the setup script, and reboot.
