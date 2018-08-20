#!/bin/bash 

# Set date for backup files
DATO=$(date +%Y%m%d%H%M%S)

# Template directories
TMPLPATH='/vagrant/files/pgpool-II'
TMPLFILE='pgpool.conf.tmpl'
TEMPDIR='/tmp'

# config directories
CONFDIR='/etc/pgpool2'
CONFFILE='pgpool.conf'
CONFBAK='pgpool.conf.'$DATO

# pool_hba.conf
TMPLHBAFILE='pool_hba.conf.tmpl'
CONFHBAFILE='pool_hba.conf'
CONFHBABAK='pool_hba.conf.'$DATO

( 
	. /vagrant/files/pgpool-II/env.sh
	envsubst < $TMPLPATH/$TMPLFILE > $TEMPDIR/$CONFFILE
	envsubst < $TMPLPATH/$TMPLHBAFILE > $TEMPDIR/$CONFHBAFILE
)

# Backup config files
cp $CONFDIR/$CONFFILE $CONFDIR/$CONFBAK
cp $CONFDIR/$CONFHBAFILE $CONFDIR/$CONFHBABAK

# Copy config files
cp $TEMPDIR/$CONFFILE $CONFDIR/$CONFFILE
cp $TEMPDIR/$CONFHBAFILE $CONFDIR/$CONFHBAFILE


# This should be created under postgresql installation
# pgpass file
PGPASSTMPL='pgpass.tmpl'
PGPASSFILE='.pgpass'
PGPATH='/var/lib/postgresql'
ROOTPATH='/root'
cp $TMPLPATH/$PGPASSTMPL $PGPASS/$PGPASSFILE
cp $TMPLPATH/$PGPASSTMPL $ROOTPATH/$PGPASSFILE

# Ensure ownership and permissions are correct
chown postgres:postgres $CONFDIR/$CONFFILE
chown postgres:postgres $CONFDIR/$CONFHBAFILE
chown postgres:postgres $PGPASS/$PGPASSFILE
chown root:root $ROOTPATH/$PGPASSFILE

chmod 0640 $CONFDIR/$CONFFILE
chmod 0640 $CONFDIR/$CONFHBAFILE
chmod 0600 $PGPASS/$PGPASSFILE
chmod 0600 $ROOTPATH/$PGPASSFILE

echo "New config installed"

systemctl restart pgpool2
