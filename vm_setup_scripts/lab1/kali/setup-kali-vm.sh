#!/bin/bash

#Run this script as sudo!!
if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi

$pwd=$(pwd)

#Configure attacker user
./configure-attacker-user.sh

#Download Windows Tools
su -c "$pwd/download-windows-tools.sh" attacker

#Install dependencies on kali
su -c "$pwd/install-dependencies.sh" attacker

#Enable ssh service
systemctl enable ssh
systemctl start ssh
echo "[i] ssh service enabled"

#Set desktop background for attacker
su -c "$pwd/set-kali-background.sh" attacker
echo "[i] Desktop background set for attacker user"

#Rename computer
echo attackerVM > /etc/hostname

#Reboot system
echo "Setup complete. The system will reboot now to finish the process."
read -n 1 -s -r -p "Press any key to continue."
reboot now
