#!/bin/bash

echo "Installing WEB-app from GitHub ..."
echo "@ASH: Install only the Node.js and frameworks for running the WEB-app here!"
echo "@ASH: Make sure that the WEB-app listen on 127.0.0.1 port 8686"
echo "@ASH: NGINX redirects traffic incomming on port 80, 443 and 8080 to 127.0.0.1 8686"
echo "@ASH: NGINX currently serves traffic to 127.0.0.1:8686"
echo "@ASH: When the WEB-app is up and running, NGINX should no longer server 127.0.0.1:8686"
echo "@ASH: Please remove it from: /etc/nginx/sites-enabled/demo.ddps.deic.dk"


