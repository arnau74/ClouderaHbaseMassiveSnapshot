#!/bin/bash
# Author Antonio Arnau arnau.antonio@gmail.com
# simple script that reads txt file (table.txt) tablename list, and create a snapshot for all tables.
# in this example we use kerberos (keytab is hbase.keytab)
createlog='./logs/create'$(date +%Y%m%d)'.log'
listasnapshot='./list_snapshot.txt'
createsnapshot='./create_snapshot.hb'
> $createlog
> $listasnapshot 
> $createsnapshot
IFS=","
while read table 
do
        echo "Table is     : $table"
	snapshot='snapshot_'${table/:/_}'_prod_'$(date +%Y%m%d)
        echo "Snapshot is  : $snapshot"
        echo $table,$snapshot >> $listasnapshot
        echo 'snapshot '\'''$table''\'','\'''$snapshot''\''' >> $createsnapshot
done < table.txt
echo 'exit' >> $createsnapshot
echo "create snapshot"
kdestroy
kinit -kt /home/snapshot/hbase.keytab hbase
hbase shell create_snapshot.hb >> $createlog 2>&1
echo "list snapshots"
echo "list snapshots" >> $createlog 2>&1
hbase org.apache.hadoop.hbase.snapshot.SnapshotInfo -list-snapshots >> $createlog 2>&1

