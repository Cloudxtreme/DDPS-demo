#!/usr/bin/env bash

# Installs a Node.js demo app into uid: 'vagrant' in ~/ and stars the app.

# @Ash: Remove the echo's below, when understood
echo "@ASH: Install only the files and requirements for running the API-app here!"
echo "@ASH: Make sure that the API-app listen on 127.0.0.1 port 9696"
echo "@ASH: NGINX redirects traffic incomming on port 9090 to 127.0.0.1 9696"
echo "@ASH: A demo Node.js API-app is running on 127.0.0.1:9696"
echo "@ASH: Just type http://ddps.deic.dk:9090 to see it run"

# Export application installation path (change PKG_NAME for other applications)
# $FILES_DIR is confiured in provision-vm.sh script and exported
export PKG_NAME="api-app"
export PKG_DIR="${FILES_DIR}/${PKG_NAME}"

# Source the env.sh file from our application setup directory
# The env.sh holds all the variables used for configuring the application
. "${PKG_DIR}/env.sh"

# Installing the application files to the home directory in the VM
echo "Installing ${PKG_DIR} in ${NODE_HOME_DIR}"
cp -af "${PKG_DIR}" "${NODE_HOME_DIR}"

# Configure the application after installing, by running the configure.sh script
# Could also be run from provision-vm.sh if you need other applications
# installed before configuring
echo "Running configure.sh to setup application"
"${PKG_DIR}/configure.sh"
