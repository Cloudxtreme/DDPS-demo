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

function create_example_database()
{
    # add data and schema to database

    gunzip -c $EXAMPLE_DATA | sed "s/__PASSWORD__/${dbpass}/g" > /tmp/test-data.sql
    chown postgres /tmp/test-data.sql

    echo 'psql -d postgres -f /tmp/test-data.sql' | su postgres > /dev/null 2>/dev/null
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

    create_example_database

    rm -f $TMPFILE
    exit 0
}


################################################################################
#
################################################################################

main $*

exit 0

