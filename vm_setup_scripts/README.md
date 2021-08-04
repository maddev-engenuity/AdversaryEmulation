# MAD ATT&CK Adversary Emulation VM Setup Instructions

This README provides instructions on configuring Kali and Windows virtual machines used in the MITRE ATT&CK Defender ATT&CK Adversary Emulation course.

---

## Install Kali 10 VM

1. Install a Kali Linux VM in the hypervisor of your choice.

We reccomend configuring the VM with the following specs:

```
OS: Latest version of Kali Linux
CPU: 2 core CPU
RAM: 8 GB
Disk: 50 GB
Networking: Should be able to ping the Windows 10 VM and reach the Internet
```

2. During OS installation, configure the hostname and username; accept default values for other options.

```
Hostname: attackerVM
Username: attacker
Password: ATT&CK
```

3. After OS install, login as the attacker user and git clone this repo to the desktop:

```bash
cd ~/Desktop
git clone git@github.com:maddev-engenuity/AdversaryEmulation.git
```

`Note: our GitHub repository requires user accounts with multi-factor authentication enabled; you may have to generate an SSH key in order to clone the repo.`

4. Run the Kali setup script as follows:

```bash
cd AdversaryEmulation/vm_setup_scripts
sudo chmod 755 setup_attack_platform.sh
./setup_attack_platform.sh
```

---

## Install Windows 10 VM

1. Install a Windows 10 VM in the hypervisor of your choice.
 
We reccomend configuring the VM with the following specs:

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

3. Decline all telemetry / Microsoft account prompts throughout OS installation.

4. After the OS has installed, login as target, open Windows Defender settings and disable all features:

```
Real Time Protection
Cloud Based Protection
Automatic Sample Submission
Tamper Protection
```

5. Install git, then git clone this repo to the user desktop:

```powershell
cd $env:userprofile\Desktop
git clone git@github.com:maddev-engenuity/AdversaryEmulation.git
```

`Note: our GitHub repository requires user accounts with multi-factor authentication enabled; you may have to generate an SSH key in order to clone the repo.`

6. Open an administrative PowerShell terminal and run the setup script as follows:

```powershell
Set-ExecutionPolicy Bypass -Force
.\setup_windows_target.ps1
```

7. Reboot the VM, log back in, and confirm Windows Defender is still disabled.

If Defender is still enabled, open Defender settings, disable all features, re-run the setup script, and reboot.
