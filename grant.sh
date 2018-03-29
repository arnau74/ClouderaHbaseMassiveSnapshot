#!/bin/bash
grantlog='./logs/grant'$(date +%Y%m%d)'.log'
if [[ $# < 3 ]] ; then
    echo 'Usage grant.sh <utente> <RWCX> <tablelist>'
    exit 1
fi
user=$1
grant=$2
filelist=$3

echo "creo script di HBASE per grant"
> $grantlog
> ./grant.hb

while read table
do
        echo "Table is     : $table"
        echo "User is  : $user"
        echo "Grant is  : $grant"
	echo 'user_permission '\'''$table''\'''  >> grant.hb
	echo 'grant '\'''$user''\'','\'''$grant''\''',''\'''$table''\''' >> grant.hb
	echo 'user_permission '\'''$table''\'''  >> grant.hb
done < $filelist
echo 'exit' >> grant.hb
echo "Lancio lo script"
kdestroy
kinit -kt /etc/security/keytabs/hbase.keytab hbase/itgrezlthd001.apps.it.wcorp.carrefour.com@APPS.IT.WCORP.CARREFOUR.COM
hbase shell grant.hb >> $grantlog 2>&1
echo "Done!"
echo "Consulta il log $grantlog"


