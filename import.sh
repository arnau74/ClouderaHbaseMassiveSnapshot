#!/bin/bash
# Author Antonio Arnau arnau.antonio@gmail.com
# simple script that reads a CSV (list_snapshot.txt) with tablename,snapshotname list and export all snapshot to a remote HDFS Cluster
# in this example remote namenode is in HA and we use kerberos (keytab is hbase.keytab)
echo "creo script di import HBASE snapshot"
> ./import.log
> ./import_snapshot.hb
IFS=","
while read table snapshot
do
        echo "Table is     : $table"
        echo "Snapshot is  : $snapshot"
        echo 'disable '\'''$table''\'''  >> import_snapshot.hb
        echo 'restore_snapshot '\'''$snapshot''\''' >> import_snapshot.hb
        echo 'enable '\'''$table''\'''  >> import_snapshot.hb
done < list_snapshot.txt
echo 'exit' >> import_snapshot.hb
echo "import snapshot"
read -p "the script will restore data on all tables, are you sure (Y/N) ? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 
fi
kdestroy
kinit -kt /home/snapshot/hbase.keytab hbase
hbase shell import_snapshot.hb >> import.log 2>&1

