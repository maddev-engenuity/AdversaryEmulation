#! /bin/bash

echo "[+] Cleaning up previously existing artifacts"
scripts/cleanup.sh

echo "[+] Prepping required files"
scripts/prep-automation.sh

echo "[+] Creating the malicious LNK payload"
tools/lnk_payload.py

echo "[+] Payload created!"
rm -f resources/loader.ps1
rm -f resources/stage1_command.ps1
rm -f resources/ds7002.lnk
rm -f resources/meterpreter.dll

