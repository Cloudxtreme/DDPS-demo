#!/bin/bash

# Here we install Node.js for running Node.js apps
# We use Linux systemd for managing Node.js apps
# Systemd services for each Node app is configured in each application

echo "@ASH: Install the Node.js framework here only!"
echo "@ASH: Do not install specific things for the WEB-app or API-app here."
echo "@ASH: Installation for WEB-app & API-app are later in the process."
echo "@ASH: Change install.sh in files/web-app and files/api-app accordingly."
echo "@ASH: The installation below is an example. Change what you want."

# Using the Ubuntu installer for Node.js v8 LTS from the official NodeSource git repo
echo "Installing Node.js v8.x ..."
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs 2>/dev/null
