#!/bin/bash
echo "[*] Setting background image for attacker user"

image_path=$(pwd)

uid=$(id -u attacker)
dbus="unix:path=/run/user/$uid/bus"

su -c "env DBUS_SESSION_BUS_ADDRESS=$dbus xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s $image_path/attacker-background.png" attacker

