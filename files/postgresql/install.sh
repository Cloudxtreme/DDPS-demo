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

    rm -f $TMPFILE
    exit 0
}


################################################################################
#
################################################################################

main $*

exit 0

