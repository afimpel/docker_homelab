#!/bin/bash
DUMP_DIR="/root/dumps/import"
db="${1,,}"
files="$2"
cd $DUMP_DIR
if [ -f "$files" ]; then
    echo -e "---\n$(date)\n---\n" > ../import.md  
    echo -e " ⛁  $db > backup: backup/${db}_beforeImport.sql"
    echo -e "# Backup database\n" >> ../import.md
    mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --databases "$db" --opt --disable-keys --dump-history --triggers > ../backup/${db}_beforeImport.sql
    size=$(du -sh ../backup/${db}_beforeImport.sql | awk '{print $1}')
    echo -e " ⛁  $db ($size)"
    echo -e "* ⛁ $db >> backup/${db}_beforeImport.sql ($size)" >> ../import.md
    echo -e "\n ⛁  $db < IMPORT: import/$files"
    echo -e "\n# Importing database\n" >> ../import.md
    mariadb -uroot -p$MARIADB_ROOT_PASSWORD $db < $files
    unix=$(date '+%Y_%m_%d-%s')
    mv -v $files ../import_done/$unix-$files
    size=$(du -sh ../import_done/$unix-$files | awk '{print $1}')
    echo " ⛁  $db ($size)"
    echo -e "* ⛁ $db << import_done/$unix-$files ($size)" >> ../import.md
    echo -e "\n---\n$(date)" >> ../import.md  
fi