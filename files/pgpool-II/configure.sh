#!/bin/bash 

# #
DATO=$(date +%Y%m%d%H%M%S)

# Template directories
TMPLPATH=$(pwd)
TMPLFILE='pgpool.conf.tmpl'
TEMPDIR='/tmp'

# config directories
CONFDIR='/etc/pgpool2'
CONFFILE='pgpool.conf'
CONFBAK='pgpool.conf.'$DATO

#
# pool_hba.conf
TMPLHBAFILE='pool_hba.conf.tmpl'

CONFHBAFILE='pool_hba.conf'
CONFHBABAK='pool_hba.conf.'$DATO

( 
	. env.sh
	envsubst < $TMPLPATH/$TMPLFILE > $TEMPDIR/$CONFFILE
	envsubst < $TMPLPATH/$TMPLHBAFILE > $TEMPDIR/$CONFHBAFILE
)

# Copy files
cp $CONFDIR/$CONFFILE $CONFDIR/$CONFBAK
cp $TEMPDIR/$CONFFILE $CONFDIR/$CONFFILE

# Backup file
cp $CONFDIR/$CONFHBAFILE $CONFDIR/$CONFHBABAK
cp $TEMPDIR/$CONFHBAFILE $CONFDIR/$CONFHBAFILE

chown postgres:postgres $CONFDIR/$CONFFILE
chown postgres:postgres $CONFDIR/$CONFHBAFILE

chmod 0640 $CONFDIR/$CONFFILE
chmod 0640 $CONFDIR/$CONFHBAFILE

echo "New config installed"

systemctl restart pgpool2
