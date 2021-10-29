#!/bin/bash
echo "[*] Setting background image for attacker user"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s /home/attacker/AdversaryEmulation/vm_setup_scripts/lab1/kali/attacker-background.png
