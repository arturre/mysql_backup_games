#!/usr/bin/env bash

export PATH=/bin:/usr/bin:$PATH

BACKUP_FOLDER="/backup"
DESTINATION="/tmp/backup_verify"

time_epoch=$1
mkdir -p ${DESTINATION} && chown -R mysql ${DESTINATION}
tar -xvf ${BACKUP_FOLDER}/mysql_backup_${time_epoch}.tar -C ${DESTINATION}/ --strip 1


#start mysql instance for verification
#quick and dirty and totally wrong server to do it 
mysqld --port 3307 --socket=/tmp/verify.mysql --datadir=${DESTINATION}  --user mysql --skip-grant-tables & 
#allow mysql to start up
sleep 10 
#check database
mysqlcheck --check  --all-databases --socket /tmp/verify.mysql || echo "BACKUP is NOT CONSISTENT" 

function cleanup {
    echo "SHUTDOWN" | mysql --socket=/tmp/verify.mysql
    rm -rf ${DESTINATION}
}

trap cleanup EXIT


