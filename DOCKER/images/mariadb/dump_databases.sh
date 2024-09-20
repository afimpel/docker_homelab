#!/bin/bash
# Directorio donde se guardarán los dumps
DUMP_DIR="/root/dumps"
mkdir -p $DUMP_DIR

# Obtener la lista de bases de datos
DBS=$(mariadb -u root -p$MARIADB_ROOT_PASSWORD -e 'SHOW DATABASES;' | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")
date > $DUMP_DIR/dumps.md
unix=$(date '+%s')
echo -e "# Dumping database:\n" >> $DUMP_DIR/dumps.md
# Realizar el dump de cada base de datos
for db in $DBS; do
    echo "  ⛁ $db"
    echo -e " *  ⛁ $db :: $DUMP_DIR/$db.sql" >> $DUMP_DIR/dumps.md
    mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --databases $db > $DUMP_DIR/$db.sql
done
cd $DUMP_DIR
echo "  "
echo "  ✔ $unix-SQL_backup.tgz"
tar -cvzf $unix-SQL_backup.tgz *.sql