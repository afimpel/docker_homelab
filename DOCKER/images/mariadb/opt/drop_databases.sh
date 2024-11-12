#!/bin/bash
# Directorio donde se guardarán los dumps
DUMP_DIR="/root/dumps"
mkdir -p $DUMP_DIR
db="${1,,}"
# Obtener la lista de bases de datos
cd $DUMP_DIR

if [ -n "$db" ]; then
    DBS=$(mariadb -u root -p$MARIADB_ROOT_PASSWORD -e "SHOW DATABASES LIKE '$db';")
    if [ -n "$DBS" ]; then
        echo -e "---\n$(date)\n---\n" > drop.md  
        echo -e " ⛁  $db > backup: backup/${db}_beforeDrop.sql"
        echo -e "# Backup database\n" >> drop.md
        mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --databases "$db" --opt --disable-keys --dump-history --triggers > backup/${db}_beforeDrop.sql
        size=$(du -sh backup/${db}_beforeDrop.sql | awk '{print $1}')
        echo -e " ⛁  $db ($size)"
        echo -e "* ⛁ $db >> backup/${db}_beforeDrop.sql ($size)" >> drop.md
        echo -e "\n ⛁  $db < DROP"
        mariadb -uroot -p$MARIADB_ROOT_PASSWORD  -e "DROP DATABASE IF EXISTS $db;"
        echo " ⛁  $db "
        echo -e "\n---\n$(date)" >> drop.md
    else
        echo -e " ⛁  NOT DB: $db"          
    fi
fi
# DROP USER 'admin'@'%'