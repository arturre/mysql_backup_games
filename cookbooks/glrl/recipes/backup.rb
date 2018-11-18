#
# Cookbook:: global-relay-mysql
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#
#
# Quick and simple mysql service 
#
#
#install nfs commons
include_recipe "nfs::server"

directory '/backup' do
  recursive true
  owner "root"
  group "root"
  mode 700
end

lvm_volume_group 'vg0' do
  physical_volumes ['/dev/sdc']
  wipe_signatures true

  logical_volume 'backup' do
    size        '100G'
    filesystem  'xfs'
    mount_point location: '/backup', options: 'noatime,nodiratime'
  end
end

nfs_export "/backup" do
  network '10.0.0.0/8'
  writeable true
  sync false
  options ['no_root_squash']
end

