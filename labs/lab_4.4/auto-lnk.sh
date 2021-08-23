#! /bin/bash

echo "[+] Cleaning up previously existing artifacts"
./cleanup.sh

echo "[+] Prepping required files"
./prep-automation.sh

echo "[+] Creating the malicious LNK payload"
./lnk_payload.py

echo "[+] Payload created!"
rm -f loader.ps1
rm -f stage1_command.ps1
rm -f ds7002.lnk
rm -f meterpreter.dll

