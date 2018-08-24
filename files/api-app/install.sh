#!/bin/bash

# Installs a Node.js app into uid: 'vagrant' ~/ and stars the app.

echo "@ASH: Install only the Node.js files and frameworks for running the API-app here!"
echo "@ASH: Make sure that the API-app listen on 127.0.0.1 port 9696"
echo "@ASH: NGINX redirects traffic incomming on port 9090 to 127.0.0.1 9696"
echo "@ASH: A demo Node.js API-app is running on 127.0.0.1:9696"
echo "@ASH: Just type http://ddps.deic.dk:9090 to see it run"


export DEBIAN_FRONTEND=noninteractive

VAGRANTPATH="/vagrant/files"
APPDIR="/home/vagrant"
APPNAME="api-app"

echo "Copying the ${APPNAME} to ${APPDIR}/${APPNAME}.."
cp -af ${VAGRANTPATH}/${APPNAME} ${APPDIR}

echo "Starting the ${APPNAME} application.."
pm2 start ${APPDIR}/${APPNAME}/api.js
pm2 save

echo "Restarting NGINX.."
sudo systemctl restart nginx
