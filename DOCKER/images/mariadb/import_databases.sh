#!/bin/bash
DUMP_DIR="/root/dumps/import"
db="$1"
files="$2"
cd $DUMP_DIR
if [ -n "$db" ]; then
    echo " ⛁  $db < IMPORT: $files"
    mariadb -uroot -p$MARIADB_ROOT_PASSWORD $db < $files
    unix=$(date '+%Y_%m_%d-%s')
    mv -v $files ../import_done/$unix-$files
fi