#!/bin/bash

# This script checks various services and reports back to user during provision.

# Check for running services

## PostgreSQL
echo "----------------------"
echo "Is PostgreSQL running?"
/usr/sbin/service postgresql status |grep Active:
echo
echo "Is PostgreSQL configuration OK?"
HBA_FILE=`sudo su postgres -c "psql -t -P format=unaligned -c 'show hba_file';"`
if [ -f $HBA_FILE ]; then
    echo "psql is running and reporting $HBA_FILE as config file: OK"
else
    echo "PostgresSQL configuration failed to load"
fi
echo

## Pgpool-II
echo "---------------------"
echo "Is Pgpool-II running?"
/usr/sbin/service pgpool2 status |grep Active:
echo
echo "Connecting to PostgreSQL via Pgpool-II and reading database"
export PGPASSWORD="password"
Q="select pg_is_in_recovery();"
Q="SELECT
 *\x
FROM flow.fastnetmoninstances where vpn_ip_addr = '192.168.67.3';"

LINES=`echo "${Q}" | psql -t -F' ' -h 127.0.0.1 -A -U flowuser -v ON_ERROR_STOP=1 -w -d netflow | wc -l`

if [ $LINES -gt 100 ]; then
  echo "Read $LINES from PostgreSQL using Pgpool-II (expected 119): OK"
else
    echo "Failed reading from PostgreSQL using Pgpool-II"
fi
echo

## NGINX
echo "-----------------"
echo "Is NGINX running?"
/usr/sbin/service nginx status |grep Active:
echo

## DDPS WEB-app
echo "-----------------------"
echo "Is the WEB-app running?"
echo "I don't know... Please write a check!"
echo

## DDPS API-app
echo "-----------------------"
echo "Is the API-app running?"
echo "I don't know... Please write a check!"
echo


# Check that network services are running correctly
## Check for IPv4 TCP services running on localhost
echo "-----------------------------------------------"
echo "TCP services listeing on localhost (127.0.0.1):"
/bin/netstat -an |grep "tcp " |grep " LISTEN " |grep 127.0.0.1 |sort -n
echo "It should be PostgreSQL(:5432), WEB-app(:8686), API-app(:9696) and pgpool-II(:9998, :9999)"
echo

## Check for TCP services running on 0.0.0.0 (all interfaces)
echo "---------------------------------------------------"
echo "TCP services listening on all interfaces (0.0.0.0):"
/bin/netstat -an |grep "tcp " |grep " LISTEN " |grep -v 127.0.0.1 |sort -n
echo "It should only be SSH(:22) and NGINX(:80, :443, :8080 & :9090)"
echo
