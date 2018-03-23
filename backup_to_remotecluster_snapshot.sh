#!/bin/bash
# Author Antonio Arnau arnau.antonio@gmail.com
# simple script that reads a CSV with tablename,snapshotname list and export all snapshot to a remote HDFS Cluster
# in this example remote namenode is in HA and we use kerberos (keytab is hbase.keytab)
echo "copy snapshot"
exportlog='./logs/export-backup'$(date +%Y%m%d)'.log'
namenode01=<your first remote nd>
namenode02=<your second remote nd>
> $exportlog
kdestroy
kinit -kt /home/snapshot/hbase.keytab hbase
active_node=''
if hadoop fs -test -e hdfs://$namenode01 ; then
active_node=$namenode01
elif hadoop fs -test -e hdfs://$namenode02 ; then
active_node=$namenode02
fi
echo "Active backup Name node is: $active_node"
IFS=","
while read table snapshot
do
        echo "Table is     : $table"
        echo "Snapshot is  : $snapshot"
        hbase org.apache.hadoop.hbase.snapshot.ExportSnapshot -snapshot $snapshot -copy-to hdfs://$active_node:8022/hbase -mappers 16 >> $exportlog 2>&1
done < list_snapshot.txt
echo "export completed-"$(date +%H%M%Y%m%d)  >> $exportlog
