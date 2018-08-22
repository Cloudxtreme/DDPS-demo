#!/bin/bash
#set -x
echo "NGINX CURRENTLY LISTENS ON TCP PORT :8686 AND :9696"
echo "THIS MUST BE DISABLED FOR THE WEB-APP AND API-APP TO WORK"
echo "PLEASE REMOVE IT FROM: /etc/nginx/sites-enabled/demo.ddps.deic.dk"

export DEBIAN_FRONTEND=noninteractive

PKG='nginx'
VAGRANTPATH='/vagrant/files'

PKGCHK=$(dpkg --get-selections|grep $PKG|grep install)
CHK=$?

if [[ $CHK -eq 0 ]]; then
	echo "$PKGCHK was installed, purging ..."
	apt-get -y purge $PKG
fi

apt-get -y install $PKG

mkdir /etc/systemd/system/nginx.service.d
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
systemctl daemon-reload
systemctl restart nginx

/bin/bash $VAGRANTPATH/$PKG/configure.sh
