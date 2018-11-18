<!-- TOC -->

- [System Requirements:](#system-requirements)
- [Setup your environment](#setup-your-environment)
- [Chef cookbooks details](#chef-cookbooks-details)
    - [Backup server glrl::backup.rb](#backup-server-glrlbackuprb)
    - [Mysql server glrl::mysql.rb](#mysql-server-glrlmysqlrb)
- [Backup script](#backup-script)
- [Verification script](#verification-script)
- [Interacting with VMS](#interacting-with-vms)
- [Destroy environment](#destroy-environment)

<!-- /TOC -->
# System Requirements:
* ubuntu OS
* sudo permissions
# Setup your environment 
* install vagrant chef and virtualbox
```bash
./install.sh
```
Please note that you need chefdk only because of berkshelf to download cookbook dependencies
* install community chef cookbooks 
```bash
pushd cookbooks/glrl && berks vendor ../ && popd
```
* Deploy VMs by running 
```bash
vagrant up
```
This will create 2 VMs mysql and backup servers and configure them using Vagrant chef-zero provisioner.
# Chef cookbooks details
## Backup server glrl::backup.rb
 * create additional volume(size configurable in Vagrant)
 * create LVM
 * create and mount xfs system 
 * export this system for mysql server as /backup using NFS
## Mysql server glrl::mysql.rb
 * create additiaonal volume for mysql data
 * create lvm for this volume as we are going to use LVM snapshots as backup strategy.We would like to create consistent backups and therefore mysql needs to be LOCKED during backup process. Therefore this period should be very short and we don't have mysql replication so LVM snapshots has to be used allowing us to take advantage of COW ( copy on write)
 * installs and configures mysql service
 * start mysql service
 * deploy backup and verification scripts. Properly should be separate cookbooks not bash scripts
 * mount backup volume from backup server via NFS
 * schedule a cron job 
# Backup script
 ```bash
 /root/mysql_backup.sh
 ```
  * uses lvm snapshots
  * LOCKs and UNLOCKs DB for short period of time flushing data to disk
  * uses tar and NFS to copy backup to backup server
  * trigger verification script
# Verification script
 is triggered by backup script and should not be triggered manually
 ```bash
 /root/mysql_verify.sh
 ```
  * opens backup file
  * starts mysqld on this data
  * uses mysqlcheck for verification
  
  Pls note that design is wrong and it should never be happening on the same server as DB, but I don't have other VMs for this purpose. Proper design will be to mount backup volume read-only on another VM, discover latest backup, make sure that this backup is recent and verify consistency. Also notification should be done much better.

  Both scripts have a room for improvements and can be written more defensive for sure.
# Interacting with VMS
  ```bash
  vagrant ssh mysql
  ps -elf | grep mysql
  mysql
  ```
  * trigger backup manually 
  ```bash 
  /root/mysql_backup.sh
  ```
  * check cron
  ```bash
    sudo su - 
    crontab -l
  ```
  * check backup server
  ```bash
  vagrant ssh backup
  ls -la /backup
  ```
# Destroy environment
  ```bash
  vagrant destroy -f 
  ```
