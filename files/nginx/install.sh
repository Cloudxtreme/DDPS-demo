#!/bin/bash
#set -x
echo "@ASH: NGINX currently listens on TCP port :8686 and :9696 for testing"
echo "@ASH: THIS MUST BE DISABLED FOR THE WEB-APP AND API-APP TO WORK!"
echo "@ASH: Please remove it from: files/nginx/demo.ddps.deic.dk.tmpl"
echo "@ASH: It's the: 'server { listen $LOCALHOST:$LOCALPORT1(2) }'.. part"

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
