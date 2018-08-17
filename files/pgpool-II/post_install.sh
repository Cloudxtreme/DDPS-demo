#!/bin/bash 
set -x

#
DATO=$(date +%Y%m%d%H%M%S)

# Template directories
TMPLPATH=$(pwd)
TMPLFILE='pgpool.conf.tmpl'
TEMPDIR='/tmp'

# config directories
CONFDIR='/etc/pgpool2'
CONFFILE='pgpool.conf'
CONFBAK='pgpool.conf.'$DATO

cp $TMPLPATH/$TMPLFILE $TEMPDIR/$TMPLFILE

sed -i -e 's/PGPOOL_LISTEN_ADDRESSES/localhost/g' $TEMPDIR/$TMPLFILE

sed -i -e 's/PGPOOL_PORT/9999/g' $TEMPDIR/$TMPLFILE

sed -i -e 's/PCP_LISTEN_ADDRESSES/localhost/g' $TEMPDIR/$TMPLFILE

sed -i -e 's/PCP_PORT/9898/g' $TEMPDIR/$TMPLFILE

sed -i -e 's/BACKEND_HOSTNAME0/localhost/g' $TEMPDIR/$TMPLFILE

sed -i -e 's/BACKEND_PORT0/5432/g'  $TEMPDIR/$TMPLFILE

sed -i -e 's/BACKEND_DATA_DIRECTORY0/'\''\/var\/lib\/postgresql\/9.6\/main'\''/g' $TEMPDIR/$TMPLFILE

# Copy files
cp -v  $CONFDIR/$CONFFILE $CONFDIR/$CONFBAK
cp -v $TEMPDIR/$TMPLFILE $CONFDIR/$CONFFILE


#
# pool_hba.conf
TMPLHBAFILE='pool_hba.conf.tmpl'

CONFHBAFILE='pool_hba.conf'
CONFHBABAK='pool_hba.conf.'$DATO

# Copy to tmp
cp $TMPLPATH/$TMPLHBAFILE $TEMPDIR/$TMPLHBAFILE

sed -i -e 's/IP4ADDRESS/127.0.0.1/g' $TEMPDIR/$TMPLHBAFILE
sed -i -e 's/IP6ADDRESS/::1/g' $TEMPDIR/$TMPLHBAFILE

sed -i -e 's/METHOD/trust/g' $TEMPDIR/$TMPLHBAFILE

# Backup file
cp -v  $CONFDIR/$CONFHBAFILE $CONFDIR/$CONFHBABAK
cp -v $TEMPDIR/$TMPLHBAFILE $CONFDIR/$CONFHBAFILE


echo "New config installed"

systemctl restart pgpool2
#BACKEND_DATA_DIRECTORY1 = '/var/lib/postgresql/9.6/main'