#!/usr/bin/env bash

export PATH=/bin:/usr/bin:$PATH

MYSQL_DATA="/dev/vg0/data"

DESTINATION="/tmp/backup_tmp"
FINAL_DESTINATION="/backup" 

pushd /root
mkdir -p ${DESTINATION} ${FINAL_DESTINATION}
time_epoch=`date +%s`
#flush and lock data
echo "FLUSH TABLES WITH READ LOCK" | mysql
#create snapshot. it's instantaneous because LVM snapshots use a copy-on-write
lvcreate -l100%FREE -s -n lvm_mysql_snapshot_${time_epoch} ${MYSQL_DATA}
#unlock mysql data
echo "UNLOCK TABLES" | mysql
#mount and copy snapshot. COMPRESSION is not required
mount -o nouuid /dev/vg0/lvm_mysql_snapshot_${time_epoch} ${DESTINATION}
tar -cpvf ${FINAL_DESTINATION}/mysql_backup_${time_epoch}.tar ${DESTINATION}
#verify
/root/mysql_verify.sh ${time_epoch}
popd

function cleanup {
    umount -f /dev/vg0/lvm_mysql_snapshot_${time_epoch}
    lvremove -f /dev/vg0/lvm_mysql_snapshot_${time_epoch}
}

trap cleanup EXIT



