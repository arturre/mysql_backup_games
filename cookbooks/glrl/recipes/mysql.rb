#
# Cookbook:: glrl
# Recipe:: mysql
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#
#
# Quick and simple mysql service 
#
#

#install nfs commons
include_recipe "nfs::default"

group 'mysql' do
  action :create
  ignore_failure true
end

user 'mysql' do
  comment 'mysql'
  group 'mysql'
  home '/data'
  action :create
  ignore_failure true
end

directory '/data' do
  owner "mysql"
  group "mysql"
end

lvm_volume_group 'vg0' do
  physical_volumes ['/dev/sdc']
  wipe_signatures true

  logical_volume 'data' do
    size        '10G'
    filesystem  'xfs'
    mount_point location: '/data', options: 'noatime,nodiratime'
  end
end

#TODO load mysql password from data bag
#passwords = data_bag_item('passwords', 'mysql')

# install mysql client
mysql_client 'default' do
  action :create
end

#install mysql service
mysql_service 'default' do
  port '3306'
  version '5.7'
  data_dir '/data'
  initial_root_password 'global_relay'
  action [:create, :start]
end

#install mysql service for verification
mysql_service 'backup' do
  port '3307'
  version '5.7'
  data_dir '/backup/verify'
  initial_root_password 'global_relay'
  action [:create]
end

#setup root password for backups
file '/root/.my.cnf' do
  content "[client] \n host=127.0.0.1 \n user=root \n password=global_relay"
  owner 'root'
  group 'root'
  mode '0600'
  action :create
end


directory '/backup' do
  owner "root"
  group "root"
end

#mount backup volume
mount '/backup' do
  device '10.0.0.2:/backup'
  fstype 'nfs'
  options 'rw'
end

#add backup script
cookbook_file '/root/mysql_backup.sh' do
  source ['mysql_backup.sh']
  mode "0700"
  owner 'root'
  group 'root'
  action :create
end

#schedule backup 
cron 'daily_backup' do
  minute '0'
  hour '0'
  command '/root/mysql_backup.sh >/var/log/mysql_backup.log 2>&1'
end

#add verification script
cookbook_file '/root/mysql_verify.sh' do
  source ['mysql_verify.sh']
  mode "0700"
  owner 'root'
  group 'root'
  action :create
end





