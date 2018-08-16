#!/bin/bash
#
# This script provisions a DDPS-demo VM from install.sh scripts in files/${application}/

# Tell Ubuntu that this is a non interactive installation
export DEBIAN_FRONTEND=noninteractive

# Root directory in the git repo is mounted inside the VM in
VAGRANTDIR=/vagrant

# Installing and configuring all the applications for running DDPS-demo
# The order is important, and executed from the top down.

echo
echo "#########################################################"
echo "# Executing each install.sh script for each application #"
echo "#########################################################"
echo
echo "########## Installing: OS Patches ##########"
  ${VAGRANTDIR}/files/os-patches/install.sh
echo
echo "########## Installing: PostgreSQL ##########"
  ${VAGRANTDIR}/files/postgresql/install.sh
echo
echo "########## Installing: Pgpool-II ##########"
  ${VAGRANTDIR}/files/pgpool-II/install.sh
echo
echo "########## Installing: NGINX ##########"
  ${VAGRANTDIR}/files/nginx/install.sh
echo
echo "########## Installing: Node.js ##########"
  ${VAGRANTDIR}/files/node/install.sh
echo
echo "########## Installing: ExaBGP ##########"
  ${VAGRANTDIR}/files/exabgp/install.sh
echo
echo "########## Installing: db2dps ##########"
  ${VAGRANTDIR}/files/db2dps/install.sh
echo
echo "########## Installing: API-app ##########"
  ${VAGRANTDIR}/files/api-app/install.sh
echo
echo "########## Installing: WEB-app ##########"
  ${VAGRANTDIR}/files/web-app/install.sh
echo
echo "#################################################################"
echo "# Installation complete: Run 'vagrant reload' to reboot VM now! #"
echo "#################################################################"
echo

exit 0
