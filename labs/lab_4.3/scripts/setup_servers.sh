#!/bin/bash

# make sure we're running this script from the lab_4.3/scripts directory
if [ ! -f "setup_servers.sh" ]; then
	echo "[-] Run this script from the lab_4.3/scripts directory. Quitting"
	exit
fi

# make sure we're running as sudo
if [ ! "$EUID" -eq 0 ]
  then echo "[-] Please run as root. Quitting"
  exit
fi

# run python3 HTTP server in the background, and store the PID of the server into a file for later reference
python3 -m http.server 80 --directory .. &
echo $! > http_server.pid
echo "[+] Started Python3 HTTP server"

# run msfconsole to start the meterpreter handler
msfconsole -r handler.rc
