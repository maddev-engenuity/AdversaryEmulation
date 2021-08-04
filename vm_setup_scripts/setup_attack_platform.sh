#!/bin/bash

# Run this script as sudo!!
if [ "$EUID" -ne 0 ]
then echo "Please run as root"
    exit
fi

echo "[*] Installing Pip3"
apt install python3-pip

echo "[*] Installing PyLNK3 version 0.4.2"
pip3 install -Iv pylnk3==0.4.2

echo "[*] Setting background image to course image"
image_path=$(pwd)
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s $image_path/attacker_background.jpg

#echo "[*] Creating new attacker user with password ATT&CK"
#useradd -m attacker
#echo "attacker:ATT&CK" | chpasswd

echo "[*] Setting background image for attacker user"
su attacker -c xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s $image_path/attacker_background.jpg

