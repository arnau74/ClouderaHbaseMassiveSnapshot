# ClouderaHbaseMassiveSnapshot
Some basic scripts that perform massive snapshot creation, export to backup cluster and massive restore


You can find a simple collection of bash scripts that I have used to manage my HBASE snapshot on Cloudera cluster.From Cloudera Manager you are able to schedule local snapshot on HBASE, but if you want to export all HBASE files to remote cluster, you must use the hbase class :  org.apache.hadoop.hbase.snapshot.ExportSnapshot

My need was to export an huge number of tables, so I have prepared some scripts, that use hbase shell and class.

-create_snapshot.sh : the script creates a snapshot for every table includes in a txt file. 
Output list_snapshots.txt that is used from the other scrips. 

-backup_to_remotecluster.sh : the script exports all snapshot previously created to your backup Cluster 

-import.sh  : the script must be run to restore the tables on the remote cluster (you must copy the file list_snapshots.txt generated from create_snapshot.sh script. 

-delete_snapshot.sh : after your activity, you can delete snapshots if not needed anymore.
