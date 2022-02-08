#!/bin/bash

# make sure we're running this script from the lab_4.3/scripts directory
if [ ! -f "shutdown_servers.sh" ]; then
	echo "[-] Run this script from the lab_4.3/scripts directory. Quitting"
	exit
fi

# make sure we're running as sudo
if [ ! "$EUID" -eq 0 ]
  then echo "[-] Please run as root. Quitting"
  exit
fi

# check if the python3 http server pid file exists
if [ ! -f "http_server.pid" ]; then
	echo "[-] HTTP Server pid file not found."
else
	# use the pid that was stored earlier to delete the correct python process
	http_server_pid=$(cat http_server.pid)
	if (ps aux | grep python | grep $http_server_pid -q); then
		kill -9 $http_server_pid
		echo "[+] Stopped Python3 HTTP server."
		rm -f http_server.pid
	else
		echo "[+] Python3 HTTP server already stopped."
	fi
fi

# get process ID of msfconsole
msf_pid=$(ps aux | grep '[m]sfconsole' | awk '{print $2}')

if [ $msf_pid ]; then
	kill -9 msf_pid
	echo "[+] Stopped msfconsole."
else
	echo "[+] msfconsole already stopped."
fi
