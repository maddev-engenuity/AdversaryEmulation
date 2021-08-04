# VM Setup

Some of the hands-on labs in this course require a specific lab environment in order for students to successfully complete them. This folder contains scripts and supplemental files for setting up the `attacker` and `target` virtual machines used in those labs.

Virtual Machines must first be installed according to the requirements below, and then the included setup scripts can be executed to complete the configuration of the machines.

## Requirements

### Operating Systems

- Attacker VM: [Kali Linux](https://www.kali.org/)
- Target VM: [Windows 10](https://www.microsoft.com/en-us/software-download/windows10ISO)

Both VMs should be created with the following minimum configuration:

- 2 Core CPU
- 50 GB disk space
- 8 GB Ram
- Have network connectivity with each other
- Have internet access
- VMWare Tools/VirtualBox Extensions installed for copy/paste between the host and VMs

## Instructions

Once the VMs have been configured as detailed above, clone this repository to each VM, and run the appropriate setup script.

```
Attacker VM:
    cd AdversaryEmulation/vm_setup_scripts
    ./setup_attack_platform.sh

Target VM:
    cd AdversaryEmulation\vm_setup_scripts
    powershell .\setup_windows_target.ps1
```

