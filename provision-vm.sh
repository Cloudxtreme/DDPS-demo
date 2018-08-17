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
  /bin/bash ${VAGRANTDIR}/files/os-patches/install.sh
echo
echo "########## Installing: OS Utilities ##########"
  /bin/bash ${VAGRANTDIR}/files/os-utilities/install.sh
echo
echo "########## Installing: Pgpool-II ##########"
  /bin/bash ${VAGRANTDIR}/files/pgpool-II/install.sh
echo
echo "########## Installing: PostgreSQL ##########"
  /bin/bash ${VAGRANTDIR}/files/postgresql/install.sh
echo
echo "########## Installing: NGINX ##########"
  /bin/bash ${VAGRANTDIR}/files/nginx/install.sh
echo
echo "########## Installing: Node.js ##########"
  /bin/bash ${VAGRANTDIR}/files/node/install.sh
echo
echo "########## Installing: ExaBGP ##########"
  /bin/bash ${VAGRANTDIR}/files/exabgp/install.sh
echo
echo "########## Installing: db2dps ##########"
  /bin/bash ${VAGRANTDIR}/files/db2dps/install.sh
echo
echo "########## Installing: API-app ##########"
  /bin/bash ${VAGRANTDIR}/files/api-app/install.sh
echo
echo "########## Installing: WEB-app ##########"
  /bin/bash ${VAGRANTDIR}/files/web-app/install.sh
echo


echo "###########################################################"
echo "# Executing each configure.sh script for each application #"
echo "###########################################################"

# postgres and pgpool2 required ahead of database restore
if [ -f ${VAGRANTDIR}/files/postgresql/configure.sh ];
then
    echo "########## Installing: PostgreSQL ##########"
      /bin/bash ${VAGRANTDIR}/files/postgresql/configure.sh
    echo
fi

echo "#################################################################"
echo "# Installation complete: Run 'vagrant reload' to reboot VM now! #"
echo "#################################################################"
echo

exit 0
