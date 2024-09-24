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
    mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --databases "$db" --compact > ${db}.sql
    size=$(stat -c %s ${db}.sql)
    echo "  ⛁ $db ($size bytes)"
    echo -e " *  ⛁ $db :: ${db}.sql ($size bytes)" >> dumps.md
else
    DBS=$(mariadb -u root -p$MARIADB_ROOT_PASSWORD -e 'SHOW DATABASES;' | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")
    date > dumps.md
    unix=$(date '+%s')
    echo -e "# Dumping database:\n" >> dumps.md
    # Realizar el dump de cada base de datos
    for db in $DBS; do
        mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --databases $db --compact > ${db}-dump.sql
        size=$(stat -c %s ${db}-dump.sql)
        echo "  ⛁ $db ($size bytes)"
        echo -e " *  ⛁ $db :: ${db}-dump.sql ($size bytes)" >> dumps.md
    done
    echo "  "
    tar -czf $unix-SQL_backup.tgz *-dump.sql dumps.md
    rm *-dump.sql
    size=$(stat -c %s $unix-SQL_backup.tgz)
    echo "  🗃 $unix-SQL_backup.tgz ($size bytes)"
    echo -e "\n 🗃 Compressed :: $unix-SQL_backup.tgz ($size bytes)" >> dumps.md
fi