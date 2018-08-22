#!/bin/bash

echo "Installing API-app from GitHub ..."
echo "Install only the Node.js and frameworks for running the API-app here!"
echo "Make sure that the API-app listen on 127.0.0.1 port 9696"
echo "NGINX redirects traffic incomming on port 9090 to 127.0.0.1 9696"
echo "NGINX currently serves traffic to 127.0.0.1:9696"
echo "When the API-app is up and running, NGINX should no longer server 127.0.0.1:9696"
echo "Please remove it from: /etc/nginx/sites-enabled/demo.ddps.deic.dk"
