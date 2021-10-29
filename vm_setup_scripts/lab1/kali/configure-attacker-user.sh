#!/bin/bash
#Configure attacker user
if id attacker &>/dev/null; then
    echo -e "ATT&CK\nATT&CK" | passwd attacker
else
    useradd -m -s /bin/bash attacker
    echo "attacker:ATT&CK" | chpasswd
fi
usermod -a attacker -G sudo
echo "[i] attacker user configured"
