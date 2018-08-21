#! /bin/bash
#
# Install the latest version of pgpool2
#
#set -x

echo "Installing pgpool ..."

MYNAME=`basename $0`
TMPFILE=`tempfile`
PGVER='9.6'
PGPOOL='pgpool2'
INSTALLATIONPATH=$(pwd)
CONFIGTMPL='$INSTALLATIONPATH/pgpool.conf.tmpl'

export DEBIAN_FRONTEND=noninteractive

DO_APT_INSTALL="TRUE"        # kasm

case $DO_APT_INSTALL in
    "TRUE")
    
    PGCHK=$(dpkg --get-selections|grep $PGPOOL|grep install)
    CHK=$?
    if [[ $CHK -eq 0 ]]; then
      apt-get -y purge $PGPOOL
      echo "pgppol2 was installed, purging ..."
    fi
    apt-get -y install $PGPOOL

    ;;
    "FALSE")
    if [ -f /opt/pgpool2/bin/pgpool_setup ]; then
        echo "pgpool2 already installed in /opt/pgpool2"
    else
        echo "$MYNAME: something else should have happened ... "

    fi

    rm -f $TMPFILE
    ;;
esac
