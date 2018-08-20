#!/bin/bash

# This script checks various services and reports back to user during provision.

## check postgres ok

HBA_FILE=`sudo su postgres -c "psql -t -P format=unaligned -c 'show hba_file';"`
echo "----------------------"
if [ -f $HBA_FILE ]; then
    echo "psql running and reporting $HBA_FILE as config file ok"
else
    echo "postgres installation failed"
fi
echo

## Check for running services
echo "----------------------"
echo "Is PostgreSQL running?"
/usr/sbin/service postgresql status |grep Active:
echo
echo "---------------------"
echo "Is pgpool-II running?"
/usr/sbin/service pgpool2 status |grep Active:
echo
echo "-----------------"
echo "Is NGINX running?"
/usr/sbin/service nginx status |grep Active:
echo
echo "-----------------------"
echo "Is the WEB-app running?"
echo "I don't know..."
echo
echo "-----------------------"
echo "Is the API-app running?"
echo "I don't know..."
echo

## Check for IPv4 TCP services running on localhost
echo "-----------------------------------------------"
echo "TCP services listeing on localhost (127.0.0.1):"
/bin/netstat -an |grep "tcp " |grep " LISTEN " |grep 127.0.0.1 |sort -n
echo "It should be PostgreSQL(:5432), pgpool-II(:9999), WEB-app(:?) and API-app(:?)"
echo

## Check for TCP services running on 0.0.0.0 (all interfaces)
echo "---------------------------------------------------"
echo "TCP services listening on all interfaces (0.0.0.0):"
/bin/netstat -an |grep "tcp " |grep " LISTEN " |grep -v 127.0.0.1 |sort -n
echo "It should only be SSH(:22), NGINX(:8080 & :9090) and pgpool-II PCP (:9898)"
echo
