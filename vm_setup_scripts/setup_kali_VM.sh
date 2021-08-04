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
