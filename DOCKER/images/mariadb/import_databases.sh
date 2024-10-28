#!/bin/bash
DUMP_DIR="/root/dumps"
mkdir -p $DUMP_DIR
db="$1"
files="$2"
cd $DUMP_DIR
if [ -n "$db" ]; then
    echo " ⛁  $db < IMPORT: $files"
    mariadb -uroot -p$MARIADB_ROOT_PASSWORD $db < $files
fi