# Setup ALL variables used to configure the application
# This file is sourced from the install.sh script

## EXPORT ALL THE VARIABLES AND SINGLE QUOTE THEM! ##


###########################
#### OS Configurations ####
###########################

## Inform the Ubuntu installer that it's a non interactive install
export DEBIAN_FRONTEND='noninteractive'

## Tmp directory in the VM
export TEMP_DIR='/tmp'


################################
#### Node.js Configurations ####
################################

## Location of the Node.js binary
export NODE_BIN='/usr/bin/node'

## Home diretory, user and group for the Node.js applications in the VM
export NODE_HOME_DIR='/home/vagrant'
export NODE_USER='vagrant'
export NODE_GROUP='vagrant'

## Node.js application, description and enviroment (used in .tmpl file)
export NODE_APP='web.js'
export NODE_APP_DESCRIPTION='Node.js WEB demo application'
export NODE_ENVIRONMENT='production'

## Node.js app IP and TCP port variables (used in the .js and .tmpl file)
## See process.env.NODE_API_(IP||PORT) in .js file
## See Environment= in systemd service file
## All Node services must run on localhost (127.0.0.1) and on differnt ports
export NODE_IP='127.0.0.1'
export NODE_PORT='8686'


################################
#### Systemd Configurations ####
################################

## Systemd template files (change $TMPL_FILE accordingly)
export SYSD_TMPL_FILE='web.node.service.tmpl'

## Systemd configuation files and directory path in VM
export SYSD_CONF_FILE='web.node.service'
export SYSD_CONF_DIR='/etc/systemd/system/'
