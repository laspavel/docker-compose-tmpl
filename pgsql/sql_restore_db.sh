#!/bin/bash

#BACKUP_DIR="/mnt/BACKUP/PS-SH-Plus/PS-P01/tmp/2022-06-09"
BACKUP_DIR="/mnt/BACKUP/"

psql -d postgres -f $BACKUP_DIR/_globals.sql

CHECK=`psql -c "\du" | grep zabbix | wc -l`

dblist=`ls $BACKUP_DIR | grep -v postgres | grep -v template0 | grep -v template1 | grep -v ".sql"`

for db in $dblist; do
#    echo Database $db
#    psql -c "drop database \"$db\""
    pg_restore --clean --create --dbname=postgres --verbose --exit-on-error --if-exists --format=d -j8 $BACKUP_DIR/$db
    let ResultCode=ResultCode+$?
done

exit

# EXAMPLE
#    psql -c "create database \"$db\""
#    psql -c "drop database 
 \"$db\""
#    pg_restore --format=d --verbose --exit-on-error --jobs=$(nproc) --dbname=$db $BACKUP_DIR/$db
#    pg_restore --clean --create --if-exists --format=d --verbose --exit-on-error --jobs=4 --dbname=$db $BACKUP_DIR/$db
#    pg_restore -c -C --if-exists -F-format=d --verbose --exit-on-error --jobs=4 --dbname=$db $BACKUP_DIR/$db
#    pg_restore -c -C -d postgres -v --if-exists -F d -j$(nproc) $BACKUP_DIR/$db
    pg_restore --clean --create --dbname=postgres --verbose --if-exists --format=d -j$(nproc) $BACKUP_DIR/$db
    let ResultCode=ResultCode+$?
