#!/bin/bash

# Here we install Node.js and the PM2 process manager for running Node.js apps.

echo "@ASH: Install the Node.js framework and package manager here only!"
echo "@ASH: Do not install specific things for the WEB-app or API-app here."
echo "@ASH: Installation for WEB-app & API-app are later in the process."
echo "@ASH: Change install.sh in files/web-app and files/api-app accordingly."
echo "@ASH: The installation below is an example. Change what you want."

# Using the Ubuntu installer for Node.js v8 LTS from the official NodeSource git repo
echo "Installing Node.js v8.x ..."
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

# Installing PM2 - a Node.js process manager (-g install npm globally)
echo "Installing PM2 ..."
sudo npm install -g pm2

echo "Generating systemd startup script for PM2 ..."
pm2 startup systemd

echo "Setting PM2 $PATH for the user: vagrant ..."
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u vagrant --hp /home/vagrant
