#! /usr/bin/env bash
#
#   Copyright 2017, DeiC, Niels Thomas Haugård
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

TMPFILE=`tempfile`
MYNAME=`basename $0`
export PATH=$PATH:/opt/db2dps/bin:/opt/mkiso/bin:/opt/pgpool2/bin
export DEBIAN_FRONTEND=noninteractive

ME=`realpath $0`
MYDIR=`dirname $ME`
EXAMPLE_DATA=$MYDIR/test-data.sql.gz

export LANGUAGE="C"
export LANG="C"
export LC_ALL="C"
export LC_CTYPE="C"

#
# functions
#

function savefile()
{
	if [ ! -f "$1" ]; then
		echo "$MYNAME: program error in function savefile, file '$1' not found"
		exit 0
	fi
	if [ ! -f "$1".org ]; then
		cp "$1" "$1".org
	fi
}

function make_sftp_user()
{
	getent passwd ddpsadm > /dev/null 2>&1  >/dev/null || adduser --home /home/ddpsadm --shell /bin/bash --gecos "DDPS admin" --ingroup staff --disabled-password ddpsadm

	if grep -q sftpgroup /etc/group
    then
         :
    else
		addgroup --system sftpgroup
    fi

	if [ -f /home/sftpgroup/newrules/.ssh/authorized_keys ]; then
		chattr -i /home/sftpgroup/newrules/.ssh/authorized_keys /home/sftpgroup/newrules/.ssh/	>/dev/null 2>&1
		rm -fr /home/sftpgroup/																	>/dev/null 2>&1
		userdel -r newrules																		>/dev/null 2>&1
	fi

	mkdir /home/sftpgroup; chown root:root /home/sftpgroup

	echo "$MYNAME: adduser 'newrules' sftp user for fastnetmon upload .... "
	getent passwd newrules >/dev/null 2>&1 >/dev/null || useradd -m -c "DDPS rules upload" -d /home/sftpgroup/newrules/ -s /sbin/nologin newrules
	usermod -G sftpgroup newrules
    usermod -p '*'       newrules

	chmod 755          /home/sftpgroup /home/sftpgroup/newrules/
	mkdir -p           /home/sftpgroup/newrules/.ssh
	chmod 700          /home/sftpgroup/newrules/.ssh
	chown -R root:root /home/sftpgroup /home/sftpgroup/newrules/

	test -d /home/sftpgroup/newrules/upload || mkdir /home/sftpgroup/newrules/upload
	chown newrules:newrules /home/sftpgroup/newrules/upload
	chmod 777 /home/sftpgroup/newrules/upload

	echo "$MYNAME: permissions for /home/sftpgroup has been set carefully, dont change"
	echo "$MYNAME: use chattr to lock / unlock /home/sftpgroup/newrules/.ssh/authorized_keys"

	chattr -i /home/sftpgroup/newrules/.ssh/
	if [ -f /home/sftpgroup/newrules/.ssh/authorized_keys ]; then
		chattr -i /home/sftpgroup/newrules/.ssh/authorized_keys
	fi
	# this is a dummy key
	cat << EOF | tr -d '\n' > /home/sftpgroup/newrules/.ssh/authorized_keys
ssh-ed25519 AAAAC3NIamAdummyKeyJustToSeIfaScriptWorksAsExprecredXXXXXXXXXXXXXXXX root@00:25:90:46:c2:fe-fastnetmon2.deic.dk
EOF
	chown -R newrules:newrules /home/sftpgroup/newrules/.ssh
	chattr +i /home/sftpgroup/newrules/.ssh   /home/sftpgroup/newrules/.ssh/*
}

function install_postgresql()
{
	# see https://www.postgresql.org/about/news/1432/
	echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list

	cat << EOF > /etc/apt/preferences.d/pgdg.pref
Package: *
Pin: release o=apt.postgresql.org
Pin-Priority: 500
EOF

	wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
	apt-get -y update >$TMPFILE
    case $? in
        0)  :
            ;;
        *)  echo "$MYNAME: failed:"
            cat $TMPFILE
    esac

    echo "installing postgresql-9.6 and related packages ... "
    apt-get -y install postgresql-9.6 postgresql-client-9.6 postgresql-client-common postgresql-common postgresql-contrib-9.6 postgresql-server-dev-9.6 sysstat libsensors4 libpq-dev > $TMPFILE
    case $? in
        0)  :
            ;;
        *)  echo "$MYNAME: failed:"
            cat $TMPFILE
            ;;
    esac

    echo "setting apt-mark hold as pgpool2 does not work with the latest postgres ... (KASM)"
    # Sæt pakkerne på hold:
    apt-mark hold postgresql-9.6 postgresql-client-9.6 postgresql-client-common postgresql-common postgresql-contrib-9.6 postgresql-server-dev-9.6

	echo "$MYNAME: installed postgresql version: `pg_config --version 2>&1`, `psql --version 2>&1`"
	# 9.4, 9.5, 9.6 ... pick the latest
	PG_HBACONF=`ls -1 /etc/postgresql/*/main/pg_hba.conf|sort -n | tail -1`

	savefile "${PG_HBACONF}"
	awk '
	{
		if ($1 == "local" && $2 == "all" && $3 == "postgres")
		{
			print $0
			print "local all flowuser peer"
			print "local all dbadmin md5"
			next
		}
		{ print; next; }
	}'	${PG_HBACONF}.org >	${PG_HBACONF}

	chmod 0640 ${PG_HBACONF}
	chown postgres:postgres ${PG_HBACONF}
	service postgresql restart
}


function create_example_database()
{
    # add data and schema to database

    gunzip -c $EXAMPLE_DATA | sed "s/__PASSWORD__/${dbpass}/g" > /tmp/test-data.sql
    chown postgres /tmp/test-data.sql

    echo 'psql -d postgres -f /tmp/test-data.sql' | su postgres > /dev/null
    /bin/rm -f /tmp/test-data.sql

    #for dbuser in ${dbusers}
    #do
	#if ! type pg_md5 >/dev/null; then 
    #    	/opt/pgpool2/bin/pg_md5 --md5auth --username=${dbuser} ${dbpass}
	#else
    #    	pg_md5 --md5auth --username=${dbuser} ${dbpass}
	#fi
    #done
}

function main()
{
    # check on how to suppress newline (found in an Oracle installation script ca 1992)
    echo="/bin/echo"
    case ${N}$C in
        "") if $echo "\c" | grep c >/dev/null 2>&1; then
            N='-n'
        else
            C='\c'
        fi ;;
    esac

    #
    # Process arguments
    #
    while getopts v opt
    do
    case $opt in
        v)  VERBOSE=TRUE
        ;;
        *)  echo "usage: $0 [-v]"
            exit
        ;;
    esac
    done
    shift `expr $OPTIND - 1`

    cd /vagrant/files/postgresql

    . /vagrant/files/postgresql/vars.SH

	install_postgresql
    make_sftp_user
    create_example_database

    rm -f $TMPFILE
    exit 0
}


################################################################################
#
################################################################################

main $*

exit 0

