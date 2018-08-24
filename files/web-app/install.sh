#!/bin/bash

# Installs a Node.js app into uid: 'vagrant' ~/ and stars the app.

echo "@ASH: Install only the Node.js files and frameworks for running the WEB-app here!"
echo "@ASH: Make sure that the WEB-app listen on 127.0.0.1 port 8686"
echo "@ASH: NGINX redirects traffic incomming on port 80 and 8080 to 127.0.0.1 8686"
echo "@ASH: A demo Node.js WEB-app is running on 127.0.0.1:8686"
echo "@ASH: Just type http://ddps.deic.dk or http://ddps.deic.dk:8080 to see it run"


export DEBIAN_FRONTEND=noninteractive

VAGRANTPATH="/vagrant/files"
APPDIR="/home/vagrant"
APPNAME="web-app"

echo "Copying the ${APPNAME} to ${APPDIR}/${APPNAME}.."
cp -af ${VAGRANTPATH}/${APPNAME} ${APPDIR}

echo "Starting the ${APPNAME} application.."
pm2 start ${APPDIR}/${APPNAME}/web.js
pm2 save

echo "Restarting NGINX.."
sudo systemctl restart nginx
