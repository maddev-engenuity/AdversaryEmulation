#!/bin/bash

# Run this script as sudo!!
if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi

#rename computer

#configure attacker user
if id attacker &>/dev/null; then
    echo -e "ATT&CK\nATT&CK" | passwd attacker
else
    useradd -m attacker
    echo "attacker:ATT&CK" | chpasswd
fi
usermod -a -G sudoers
echo "[i] attacker user configured"

su -c "./download-windows-executables.sh" attacker

su -c "./install-dependencies.sh" attacker

systemctl enable ssh
systemctl start ssh
echo "[i] ssh service enabled"

#Set desktop background for attacker
su -c "./set-kali-background.sh" attacker
echo "[i] Desktop background set for attacker user"

#Reboot system
echo "Setup complete. The system will reboot now to finish the process."
read -n 1 -s -r -p "Press any key to continue."
