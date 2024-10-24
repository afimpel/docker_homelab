#!/bin/bash
# Directorio donde se guardarán los dumps
DUMP_DIR="/root/dumps"
mkdir -p $DUMP_DIR
db="$1"
# Obtener la lista de bases de datos
cd $DUMP_DIR
if [ -n "$db" ]; then
    date > dumps.md
    echo -e "# Dumping database:\n" >> dumps.md
    mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --databases "$db" --opt --compact --disable-keys --dump-history --triggers > ${db}.sql
    size=$(du -sh ${db}.sql | awk '{print $1}')
    echo " ⛁  $db ($size)"
    echo -e " *  ⛁ $db :: ${db}.sql ($size)" >> dumps.md
else
    DBS=$(mariadb -u root -p$MARIADB_ROOT_PASSWORD -e 'SHOW DATABASES;' | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")
    mkdir -p "database"
    date > dumps.md
    echo -e "# Dumping database:\n" >> dumps.md
    cd database
    rm *
    unix=$(date '+%Y_%m_%d-%s')
    # Realizar el dump de cada base de datos
    for db in $DBS; do
        mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --databases $db --opt --compact --disable-keys --dump-history --triggers  > ${db}.sql
        size=$(du -sh ${db}.sql | awk '{print $1}')
        echo " ⛁  $db ($size)"
        echo -e " *  ⛁ $db :: ${db}.sql ($size)" >> ../dumps.md
    done
    echo "  "
    tar -czf ../$unix-SQL_backup.tgz *.sql
    cd ..
    size=$(du -sh $unix-SQL_backup.tgz | awk '{print $1}')
    echo "  🗃 $unix-SQL_backup.tgz ($size)"
    echo -e "\n 🗃 Compressed :: $unix-SQL_backup.tgz ($size)" >> dumps.md
fi