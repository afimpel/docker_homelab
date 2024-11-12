#!/bin/bash

DUMP_DIR="/root/dumps"
mkdir -p $DUMP_DIR
db="$1"

cd $DUMP_DIR
if [ -n "$db" ]; then
    echo -e "---\n$(date)\n---\n" > dumps.md  

    echo -e "# Backup database\n" >> dumps.md
    mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --databases "$db" --opt --disable-keys --dump-history --triggers > backup/${db}.sql
    size=$(du -sh backup/${db}.sql | awk '{print $1}')
    echo " ⛃  $db ($size)"
    echo -e "* ⛃ $db :: ${db}.sql ($size)" >> dumps.md
    echo -e "\n---\n$(date)" >> dumps.md  
else
    find . -name "*.tgz" -mtime -15 -exec rm {} \;
    DBS=$(mariadb -u root -p$MARIADB_ROOT_PASSWORD -e 'SHOW DATABASES;' | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

    mkdir -p "database"
    echo -e "---\n$(date)\n---\n" > dumps.md  

    echo -e "# Dumping\n" >> dumps.md

    echo -e "## Users database\n" >> dumps.md
    mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --system=users > system-all-databases.sql
    size=$(du -sh system-all-databases.sql | awk '{print $1}')
    echo " 👤  SYSTEM ALL DATA ($size)"
    echo -e "* 👤 SYSTEM ALL DATA :: system-all-databases.sql ($size)" >> dumps.md

    echo -e "\n## Dumping database\n" >> dumps.md
    cd database
    rm *
    unix=$(date '+%Y_%m_%d-%s')

    for db in $DBS; do
        mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --databases $db --opt --disable-keys --dump-history --triggers > ${db}.sql
        size=$(du -sh ${db}.sql | awk '{print $1}')
        echo " ⛃  $db ($size)"
        echo -e "* ⛃ $db :: ${db}.sql ($size)" >> ../dumps.md
    done

    echo "  "
    cd ..
    tar -czf $unix-SQL_backup.tgz *.sql */*.sql
    size=$(du -sh $unix-SQL_backup.tgz | awk '{print $1}')
    echo " 🗃 $unix-SQL_backup.tgz ($size)"
    echo -e "\n 🗃 Compressed :: $unix-SQL_backup.tgz ($size)" >> dumps.md
    echo -e "\n---\n$(date)" >> dumps.md  
fi