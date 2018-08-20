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

# pool_hba.conf
TMPLHBAFILE='pool_hba.conf.tmpl'
CONFHBAFILE='pool_hba.conf'
CONFHBABAK='pool_hba.conf.'${DATO}

( 
	. ${FILESDIR}/nginx/env.sh
	envsubst < ${TMPLPATH}/${TMPLFILE} > ${TEMPDIR}/${CONFFILE}
	#envsubst < $TMPLPATH/$TMPLHBAFILE > $TEMPDIR/$CONFHBAFILE
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


# Reload configuration
systemctl restart nginx

# For test print status
systemctl status nginx

netstat -tulpn
