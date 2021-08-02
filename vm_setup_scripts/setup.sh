#!/bin/bash

# Run this script as sudo!!
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Install pip3
apt install python3-pip

# Install PyLNK3-0.4.2
pip3 install -Iv pylnk3==0.4.2

