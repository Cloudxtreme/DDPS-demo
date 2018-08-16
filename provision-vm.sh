#!/bin/bash
#
# This script runs every install script in install.d/
# It logs output from each script to /var/log on the VM

export DEBIAN_FRONTEND=noninteractive

VAGRANTDIR=/vagrant

echo "Executing each install-script in files"

cd ${VAGRANTDIR}/scripts/vm-install.d
find . -type f -name '*.sh' | sort -n | while read SHELLSCRIPT
  do
	  echo "########## Running: ${SHELLSCRIPT} ##########"
    bash ${SHELLSCRIPT} 2>&1 
  done

exit 0
