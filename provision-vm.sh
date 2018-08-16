#!/bin/bash
#
# This script provisions a DDPS-demo VM from install.sh scripts in files/${application}/

export DEBIAN_FRONTEND=noninteractive

# Root directory in the git repo is mounted inside the VM in
VAGRANTDIR=/vagrant


# Installing and configuring all the applications for running DDPS-demo
# The order is important, and executed from the top down.

echo "Executing each install.sh script in all the folders in files/"
echo "#############################################################"

echo "########## Installing: OS Patches ##########"
  ${VAGRANTDIR}/files/os-patches/install.sh

echo "########## Installing: PostgreSQL ##########"
  ${VAGRANTDIR}/files/postgresql/install.sh

echo "########## Installing: Pgpool-II ##########"
  ${VAGRANTDIR}/files/pgpool-II/install.sh

echo "########## Installing: NGINX ##########"
  ${VAGRANTDIR}/files/nginx/install.sh

echo "########## Installing: Node.js ##########"
  ${VAGRANTDIR}/files/node/install.sh

echo "########## Installing: ExaBGP ##########"
  ${VAGRANTDIR}/files/exabgp/install.sh

echo "########## Installing: db2dps ##########"
  ${VAGRANTDIR}/files/db2dps/install.sh

echo "########## Installing: API-app ##########"
  ${VAGRANTDIR}/files/api-app/install.sh

echo "########## Installing: WEB-app ##########"
  ${VAGRANTDIR}/files/web-app/install.sh

echo "###########################################################"
echo "Installation complete: Run $ 'vagrant reload' to reboot VM!"
echo "###########################################################"

exit 0
