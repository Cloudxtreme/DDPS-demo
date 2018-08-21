#!/bin/bash
#set -x
echo "Installing NGINX ..."
echo "Make sure that NGINX listen on 0.0.0.0 port 8080 and 9090!"
echo "NGINX must redirect traffic on port 8080 and 9090 to the Node-apps on localhost."
echo "E.g. if the Node.js API-app listen on 127.0.0.1:9696"
echo "NGINX must redirect traffic incomming on 0.0.0.0:9090 to 127.0.0.1:9696"
echo "Same thing for the Node.js WEB-app!"

export DEBIAN_FRONTEND=noninteractive

PKG='nginx'
VAGRANTPATH='/vagrant/files'

PKGCHK=$(printf $(dpkg --get-selections|grep $PKG|grep install))
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
