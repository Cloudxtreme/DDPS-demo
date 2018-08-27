#!/bin/bash 
#set -x
# Set date for backup files
DATO=$(date +%Y%m%d%H%M%S)

# Vagrant path
VAGRANTDIR=/vagrant
FILESDIR=${VAGRANTDIR}/files

# Template directories
TMPLPATH=${FILESDIR}'/nginx'
TMPLFILE='demo.ddps.deic.dk.tmpl'
TEMPDIR='/tmp'

# config directories
CONFDIR='/etc/nginx'
AVAILABLE=${CONFDIR}'/sites-available'
ENABLED=${CONFDIR}'/sites-enabled'
CONFFILE='demo.ddps.deic.dk'
CONFBAK=${AVAILABLE}/${CONFFILE}.${DATO}

( 
	. ${FILESDIR}/nginx/env.sh
	envsubst < ${TMPLPATH}/${TMPLFILE} > ${TEMPDIR}/${CONFFILE}
)

# Backup files
if [[ -f ${CONFDIR}/${CONFFILE} ]]; then
	cp -v ${CONFDIR}/${CONFFILE} ${CONFBAK}
fi

# For testing
if [[ ! -f '/opt/ngx/ddosgui' ]]; then
	mkdir -p /opt/ngx/ddosgui
	cp -v /var/www/html/* /opt/ngx/ddosgui/
fi

# Copy files
cp -v ${TEMPDIR}/${CONFFILE} ${AVAILABLE}/${CONFFILE}

# Permissions / ownership

# Create symlink
ln -sf ${AVAILABLE}/${CONFFILE} ${ENABLED}/${CONFFILE}

# Remove default server
rm -fv ${ENABLED}/default

# Reload configuration
systemctl restart nginx
