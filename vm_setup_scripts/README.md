# MAD ATT&CK Adversary Emulation VM Setup Instructions

Some of the hands-on labs in this course require a specific lab environment in order for students to successfully complete them. This folder contains scripts and supplemental files for setting up the `attacker` and `target` virtual machines used in those labs.

Virtual Machines must first be installed according to the requirements below, and then the included setup scripts can be executed to complete the configuration of the machines.

## Install Kali 10 VM

1. Install a Kali Linux VM in the hypervisor of your choice.

We recommend configuring the VM with the following specs:

```
OS: Latest version of Kali Linux (64-bit)
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

4. Open a terminal running as user 'attacker'; copy and paste these commands:

```bash
cd ~/Desktop/AdversaryEmulation/vm_setup_scripts
chmod 755 setup_kali_VM.sh
chmod 755 set_kali_wallpaper.sh
./set_kali_wallpaper.sh
sudo ./setup_kali_VM.sh
```

---

## Install Windows 10 VM

1. Install a Windows 10 VM in the hypervisor of your choice.
 
We reccomend configuring the VM with the following specs:

```
OS: Windows 10 Professional (64-bit)
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
cd $env:USERPROFILE\Desktop\AdversaryEmulation\vm_setup_scripts
.\setup_windows10_VM.ps1
```

7. Reboot the VM, log back in, and confirm Windows Defender is still disabled.

If Defender is still enabled, open Defender settings, disable all features, re-run the setup script, and reboot.
