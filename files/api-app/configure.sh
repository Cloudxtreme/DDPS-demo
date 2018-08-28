#!/usr/bin/env bash

# This configures, enables and starts a systemd service for a Node.js app 

# All variables are sourced from the env.sh file by the install.sh script

# Substitute relevant env.sh variables in the .tmpl file and create a valid
# config file ($CONF_FILE) using envsubst in /tmp on the VM
( envsubst < ${PKG_DIR}/${SYSD_TMPL_FILE} > ${TEMP_DIR}/${SYSD_CONF_FILE} )

# Copy configuraiton files from $TEMP_DIR to $CONF_DIR
echo "Copying final Node.js systemd service configuration file to /etc"
cp -v ${TEMP_DIR}/${SYSD_CONF_FILE} ${SYSD_CONF_DIR}

# Reload systemd after creating a .service file
echo "Reloading the systemd daemon after creating a new .service file"
systemctl daemon-reload

# Enable the systemd configuration file
echo "Enable Node.js systemd service"
systemctl enable ${SYSD_CONF_FILE} 2>/dev/null

# Start the systemd configuration file
echo "Start Node.js systemd service"
systemctl start ${SYSD_CONF_FILE}

# Restart NGINX after starting the systemd controlled Node.js app
echo "Restarting NGINX after Node.js service is running"
systemctl restart nginx
