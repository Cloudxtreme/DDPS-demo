#!/bin/bash

echo "Installing API-app from GitHub ..."
echo "@ASH: Install only the Node.js and frameworks for running the API-app here!"
echo "@ASH: Make sure that the API-app listen on 127.0.0.1 port 9696"
echo "@ASH: NGINX redirects traffic incomming on port 9090 to 127.0.0.1 9696"
echo "@ASH: NGINX currently serves traffic to 127.0.0.1:9696"
echo "@ASH: When the API-app is up and running, NGINX should no longer server 127.0.0.1:9696"
echo "@ASH: Please remove it from: /etc/nginx/sites-enabled/demo.ddps.deic.dk"
