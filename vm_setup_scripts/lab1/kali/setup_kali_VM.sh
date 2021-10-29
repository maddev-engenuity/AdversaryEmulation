#!/bin/bash

# Run this script as sudo!!
if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi

#configure attacker user
if id attacker &>/dev/null; then
    echo -e "ATT&CK\nATT&CK" | passwd attacker
else
    useradd -m attacker
    echo "attacker:ATT&CK" | chpasswd
fi
usermod -a -G sudoers

su -c "./download-windows-executables.sh" attacker
su -c "./install-dependencies.sh" attacker

systemctl enable ssh
systemctl start ssh

#Set desktop background for attacker
echo "[i] Setting desktop background for attacker user"
su -c "./set-kali-background.sh" attacker

#Reboot system
echo "Setup complete. The system will reboot now to finish the process."
read -n 1 -s -r -p "Press any key to continue."
