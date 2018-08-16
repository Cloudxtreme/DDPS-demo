#!/bin/bash
#
# This script runs every install script in install.d/
# It logs output from each script to /var/log on the VM

export DEBIAN_FRONTEND=noninteractive

# Root directory in the git repo is mounted inside the VM in
VAGRANTDIR=/vagrant


# Installing and configuring all the applications for running DDPS-demo
echo "Executing each install.sh script in all the folders in files/"
echo "#############################################################"

echo "########## Installing: OS Patches ##########"
  ${VAGRANTDIR}/os-patches/install.sh

echo "########## Installing: PostgreSQL ##########"
  ${VAGRANTDIR}/postgresql/install.sh

echo "########## Installing: Pgpool-II ##########"
  ${VAGRANTDIR}/pgpool-II/install.sh

echo "########## Installing: NGINX ##########"
  ${VAGRANTDIR}/nginx/install.sh

echo "########## Installing: Node.js ##########"
  ${VAGRANTDIR}/node/install.sh

echo "########## Installing: ExaBGP ##########"
  ${VAGRANTDIR}/exabgp/install.sh

echo "########## Installing: db2dps ##########"
  ${VAGRANTDIR}/db2dps/install.sh

echo "########## Installing: API-app ##########"
  ${VAGRANTDIR}/api-app/install.sh

echo "########## Installing: WEB-app ##########"
  ${VAGRANTDIR}/web-app/install.sh

echo "#####################"
echo "Installation complete"
echo "#####################"

exit 0
