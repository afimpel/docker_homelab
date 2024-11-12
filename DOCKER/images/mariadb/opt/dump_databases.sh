#!/bin/bash
# Directorio donde se guardarán los dumps
DUMP_DIR="/root/dumps"
mkdir -p $DUMP_DIR
db="$1"
# Obtener la lista de bases de datos
cd $DUMP_DIR
if [ -n "$db" ]; then
    echo -e "---\n$(date)\n---\n" > dumps.log  
    echo -e "# Backup database\n" >> dumps.log
    mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --databases "$db" --opt --disable-keys --dump-history --triggers > backup/${db}.sql
    size=$(du -sh backup/${db}.sql | awk '{print $1}')
    echo " ⛁  $db ($size)"
    echo -e "* ⛁ $db :: ${db}.sql ($size)" >> dumps.log
    echo -e "\n---\n$(date)" >> dumps.log  
else
    find . -name "*.tgz" -mtime -15 -exec rm {} \;
    DBS=$(mariadb -u root -p$MARIADB_ROOT_PASSWORD -e 'SHOW DATABASES;' | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")
    mkdir -p "database"
    echo -e "---\n$(date)\n---\n" > dumps.log  
    echo -e "# Dumping database\n" >> dumps.log
    cd database
    rm *
    unix=$(date '+%Y_%m_%d-%s')
    # Realizar el dump de cada base de datos
    for db in $DBS; do
        mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --databases $db --opt --disable-keys --dump-history --triggers  > ${db}.sql
        size=$(du -sh ${db}.sql | awk '{print $1}')
        echo " ⛁  $db ($size)"
        echo -e "* ⛁ $db :: ${db}.sql ($size)" >> ../dumps.log
    done
    echo "  "
    cd ..
    tar -czf $unix-SQL_backup.tgz import_done/*.sql database/*.sql backup/*.sql
    size=$(du -sh $unix-SQL_backup.tgz | awk '{print $1}')
    echo " 🗃 $unix-SQL_backup.tgz ($size)"
    echo -e "\n 🗃 Compressed :: $unix-SQL_backup.tgz ($size)" >> dumps.log
    echo -e "\n---\n$(date)" >> dumps.log  
fi