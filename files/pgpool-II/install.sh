#! /bin/bash
#
# Install the latest version of pgpool2
#
# set -x

echo "Installing pgpool ..."

MYNAME=`basename $0`
TMPFILE=`tempfile`
PGVER='9.6'
PGPOOL='pgpool2'
INSTALLATIONPATH=$(pwd)
CONFIGTMPL='$INSTALLATIONPATH/pgpool.conf.tmpl'

#$INSTALLATIONPATH/pre_install.sh

export DEBIAN_FRONTEND=noninteractive

DO_APT_INSTALL="TRUE"        # kasm

case $DO_APT_INSTALL in
    "TRUE")
    PGCHK=$(printf $(dpkg --get-selections|grep $PGPOOL|grep install))
    CHK=$?
    if [[ $CHK -eq 0 ]]; then
      apt-get -y purge $PGPOOL
      echo "pgppol2 was installed, purging ..."
    fi
    apt-get -y install $PGPOOL

    # Create new config file from template
    $INSTALLATIONPATH/post_install.sh
  
    ;;
    "FALSE")
    if [ -f /opt/pgpool2/bin/pgpool_setup ]; then
        echo "pgpool2 already installed in /opt/pgpool2"
    else
        echo "$MYNAME: installing autoconf bison byacc ... "
        # apt-get install -y git autoconf bison byacc flex libtool > $TMPFILE
        # case $? in
        #     0)  echo "done"
        #         ;;
        #     *)  echo "failed:"
        #         cat $TMPFILE
        #         ;;
        # esac
            
        # test -d /usr/local/src || mkdir /usr/local/src
        # cd /usr/local/src/

        # test -d pgpool2 && rm -fr pgpool2

        # echo "$MYNAME: installing pgpool2 from git ... src in `pwd`/pgpool2 "
        # git clone https://github.com/pgpool/pgpool2.git

        # cd pgpool2/

        # echo "compiling ... "
        # (
        # touch configure.ac aclocal.m4 configure Makefile.am Makefile.in
        # autoreconf -fi
        # ./configure --prefix=/opt/pgpool2
        # automake
        # make install
        # make clean
        # ) > $TMPFILE
        # if [ -f /opt/pgpool2/bin/pgpool_setup ]; then
        #     echo "pgpool2 installed in /opt/pgpool2"
        # else
        #     echo "installation failed:"
        #     cat $TMPFILE
        # fi
    fi

    # logit "Append /opt/db2dps/bin and /opt/mkiso/bin to PATH ... "
    # Installed in non-default location, so add PATH 

    # echo 'PATH=$PATH:/opt/pgpool2/bin' > /etc/profile.d/pgpool2.sh
    # chmod 644 /etc/profile.d/pgpool2.sh
    # chown root:root /etc/profile.d/pgpool2.sh

    # echo "added /etc/profile.d/pgpool2.sh as pgpool is installed in /opt/pgpool2"

    # echo 'd /var/run/pgpool/ 0755 postgres postgres - ' > /etc/tmpfiles.d/pgpool.conf
    # echo "added /etc/tmpfiles.d/pgpool.conf"

    # mkdir /var/log/pgpool
    # chown syslog:adm /var/log/pgpool

    # # create extension ...
    # cd /usr/local/src/pgpool2/src/sql/pgpool-recovery/
    # make install
    # echo 'create extension pgpool_recovery ; select * from pg_extension ;' | sudo su - postgres -c "cd /tmp; psql -d netflow -U postgres -p 5432"

    # echo "No config has been applied"

    rm -f $TMPFILE
    ;;
esac
