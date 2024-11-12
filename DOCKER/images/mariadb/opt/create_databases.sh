#!/bin/bash
# Directorio donde se guardarán los dumps
DUMP_DIR="/root/dumps"
mkdir -p $DUMP_DIR
db="$1"
# Obtener la lista de bases de datos
cd $DUMP_DIR
unix=$(date '+%Y_%m_%d-%s')
if [ -n "$db" ]; then
    DBS=$(mariadb -u root -p$MARIADB_ROOT_PASSWORD -e "SHOW DATABASES LIKE '$db';")
    if [ ! -n "$DBS" ]; then
        echo -e "---\n$(date)\n---\n" > create.log
        echo -e "\n ⛁  $db > CREATE"
        cp /opt/db/sql-create.sql /tmp/sql-create.sql
        dbuser=$(echo "$db" | cut -d "_" -f 1)
        echo -e "# Creating database\n" >> create.log

        sed -i "s/USERNAME/${dbuser}/g" /tmp/sql-create.sql
        sed -i "s/MARIADB_ROOT_PASSWORD/${MARIADB_ROOT_PASSWORD}/g" /tmp/sql-create.sql
        sed -i "s/DATABASE/${db}/g" /tmp/sql-create.sql

        more /tmp/sql-create.sql
        # mariadb -uroot -p$MARIADB_ROOT_PASSWORD  -e "CREATE SCHEMA IF NOT EXISTS $db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '${COMPOSE_PROJECT_NAME^^} -- $db';"
        # 
        # mariadb -uroot -p$MARIADB_ROOT_PASSWORD  -e "GRANT ALL PRIVILEGES ON $dbu\_%.* TO $dbu@% IDENTIFIED BY '$MARIADB_ROOT_PASSWORD' WITH GRANT OPTION;"
        # mariadb -uroot -p$MARIADB_ROOT_PASSWORD  -e "GRANT ALL PRIVILEGES ON $dbu\_%.* TO adminer@% WITH GRANT OPTION;"
        echo " ⛁  $db :: USR: ${dbuser}"
        echo -e "* ⛁  $db :: USR: ${dbuser}" >> create.log
        echo -e "\n---\n$(date)" >> create.log
    else
        echo -e " ⛁  Exist DB: $db"          
    fi
fi
