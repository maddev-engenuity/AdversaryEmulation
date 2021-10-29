#!/bin/bash
#Configure attacker user
if id attacker &>/dev/null; then
    echo -e "ATT&CK\nATT&CK" | passwd attacker
else
    useradd -m attacker
    echo "attacker:ATT&CK" | chpasswd
fi
usermod -a -G sudoers
echo "[i] attacker user configured"