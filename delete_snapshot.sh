#!/bin/bash
# Author Antonio Arnau arnau.antonio@gmail.com
# simple script that reads simple script that reads a CSV (list_snapshot.txt) with tablename,snapshotname tablename list, and delete the a snapshots
# in this example we use kerberos (keytab is hbase.keytab)
deletelog='./logs/delete'$(date +%Y%m%d)'.log'
> $deletelog
> ./delete_snapshot.hb
IFS=","
while read table snapshot
do
        echo "Table is     : $table"
        echo "Snapshot is  : $snapshot"
        echo 'delete_snapshot '\'''$snapshot''\''' >> delete_snapshot.hb
done < list_snapshot.txt
echo 'exit' >> delete_snapshot.hb
echo "delete snapshot"
kdestroy
kinit -kt /home/snapshot/hbase.keytab hbase
hbase shell delete_snapshot.hb >> $deletelog 2>&1
echo "lista snapshot"
echo "lista snapshot" >> $deletelog 2>&1
hbase org.apache.hadoop.hbase.snapshot.SnapshotInfo -list-snapshots >> $deletelog 2>&1
