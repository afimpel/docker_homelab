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
cd $DUMP_DIR
for db in $DBS; do
    mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD --databases $db > $db.sql
    size=$(stat -c %s $db.sql)
    echo "  ⛁ $db ($size bytes)"
    echo -e " *  ⛁ $db :: $db.sql ($size bytes)" >> dumps.md
done
echo "  "
tar -czf $unix-SQL_backup.tgz *.sql
size=$(stat -c %s $unix-SQL_backup.tgz)
echo "  🗃 $unix-SQL_backup.tgz ($size bytes)"
echo -e "\n 🗃 Compressed :: $unix-SQL_backup.tgz ($size bytes)" >> dumps.md
