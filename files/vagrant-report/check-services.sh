#!/bin/bash

# This script checks various services and reports back to user during provision.

## Check for TCP services running on localhost
echo "-----------------------------------"
echo "TCP services listeing on localhost:"
/bin/netstat -an |grep "tcp " |grep " LISTEN " |grep 127.0.0.1
echo "It should be PostgreSQL(:5432), pgpool-II(:?), WEB-app(:?) and API-app(:?)"
echo

## Check for TCP services running on 0.0.0.0 (all interfaces)
echo "-----------------------------------------"
echo "TCP services listening on all interfaces:"
/bin/netstat -an |grep "tcp " |grep " LISTEN " |grep -v 127.0.0.1
echo "It should only be SSH(:22) and NGINX(:8080 & :9090)!"
echo
