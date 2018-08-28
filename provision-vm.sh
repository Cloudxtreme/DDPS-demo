#!/bin/bash
#
# This script provisions a DDPS-demo VM from install.sh scripts in files/${application}/

# Tell Ubuntu that this is a non interactive installation
export DEBIAN_FRONTEND='noninteractive'

# Root directory in the git repo is mounted inside the VM in $VAGRANT_DIR
# Export the variables so they can be used in multiple install.sh and
# configure.sh scritps to configure different applications
export VAGRANT_DIR='/vagrant'
export FILES_DIR=${VAGRANT_DIR}'/files'

# Installing all the applications for running the DDPS-demo VM
# The order is important, and executed from the top down!
# Some applications have dependencies, that require a later config step
# Lastly we check that the services are configured correctly

echo "#########################################################"
echo "# Executing each install.sh script for each application #"
echo "#########################################################"
echo

echo "########## Installing: OS Patches ##########"
  /bin/bash ${FILES_DIR}/os-patches/install.sh
echo
echo "########## Installing: OS Utilities ##########"
  /bin/bash ${FILES_DIR}/os-utilities/install.sh
echo
echo "########## Installing: PostgreSQL ##########"
  /bin/bash ${FILES_DIR}/postgresql/install.sh
echo
echo "########## Installing: Pgpool-II ##########"
  /bin/bash ${FILES_DIR}/pgpool-II/install.sh
echo
echo "########## Installing: NGINX ##########"
  /bin/bash ${FILES_DIR}/nginx/install.sh
echo
echo "########## Installing: Node.js ##########"
  /bin/bash ${FILES_DIR}/node/install.sh
echo
echo "########## Installing: ExaBGP ##########"
  /bin/bash ${FILES_DIR}/exabgp/install.sh
echo
echo "########## Installing: db2dps ##########"
  /bin/bash ${FILES_DIR}/db2dps/install.sh
echo
echo "########## Installing: API-app ##########"
  /bin/bash ${FILES_DIR}/api-app/install.sh
echo
echo "########## Installing: WEB-app ##########"
  /bin/bash ${FILES_DIR}/web-app/install.sh
echo

echo "###########################################################"
echo "# Configuring some applications from configure.sh scripts #"
echo "###########################################################"
echo

# Pgpool-II should be configured after PostgreSQL but before database restore
if [ -f ${FILES_DIR}/postgresql/configure.sh ]; then
  echo "########## Configuring: pgpool-II ##########"
    /bin/bash ${FILES_DIR}/pgpool-II/configure.sh
  echo
fi

# Database restore requires both PostgreSQL and Pgpool-II.
if [ -f ${FILES_DIR}/postgresql/configure.sh ]; then
  echo "########## Configuring: PostgreSQL ##########"
    /bin/bash ${FILES_DIR}/postgresql/configure.sh
  echo
fi

echo "##########################################################"
echo "# Verifying services are started and listening correctly #"
echo "##########################################################"

echo 
  /bin/bash ${FILES_DIR}/vagrant-report/check-services.sh
echo

echo "#########################################################"
echo "# Installation complete: Please check the output above! #"
echo "#########################################################"

exit 0
