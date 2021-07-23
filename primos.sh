#!/bin/bash
# primos
#
# Primos shell script for running a motif search and sorting results
#
#
if [ -z "$PRIMOSBASE" ];then
    export PRIMOSBASE=`dirname $0`
fi

$PRIMOSBASE/prilaunch.pl
chmod +x step1.sh
./step1.sh

