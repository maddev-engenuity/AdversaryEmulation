#!/bin/bash

echo "[i] Installing Pip3"
apt update
apt install -y python3-pip

echo "[i] Installing PyLNK3 version 0.4.2"
su -c "pip3 install -Iv pylnk3==0.4.2" attacker

echo "[i] Dependencies installed"
