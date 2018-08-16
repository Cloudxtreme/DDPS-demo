#!/bin/bash

echo "Installing NGINX ..."
echo "Make sure that NGINX listen on 0.0.0.0 port 8080 and 9090!"
echo "The NGINX must redirect traffic coming in on port 8080 and 9090 to the Node apps on localhost."
echo "If the Node API-app listen on 127.0.0.1:9999 NGINX must redirect port 9090 to 127.0.0.1:9999"
