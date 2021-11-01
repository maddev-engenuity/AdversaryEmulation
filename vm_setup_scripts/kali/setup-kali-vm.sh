#!/bin/bash

#Run this script as sudo!!
if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi

pwd=$(pwd)
echo $pwd

#Configure attacker user
./configure-attacker-user.sh

#Install dependencies on kali
./install-dependencies.sh

#Enable ssh service
systemctl enable ssh
systemctl start ssh
echo "[i] ssh service enabled"

#Copy repo to attacker user's home folder
cp -r ../../../AdversaryEmulation /home/attacker/AdversaryEmulation
chown -R attacker:attacker /home/attacker/AdversaryEmulation

#Set desktop wallpaper for attacker
echo /home/attacker/AdversaryEmulation/vm_setup_scripts/lab1/kali/set-kali-wallpaper.sh >> /home/attacker/.bashrc
echo "[i] Desktop wallpaper will be set for attacker user when they login"

#Rename computer
echo attackerVM > /etc/hostname
sed -i 's/kali/attackerVM/g' /etc/hosts

#Reboot system
echo "Setup complete. The system will reboot now to finish the process."
read -n 1 -s -r -p "Press any key to continue."
reboot now
