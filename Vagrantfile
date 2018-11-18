# -*- mode: ruby -*-
# vi: set ft=ruby :
    #mysql.vm.customize ['createhd', '--filename', mysql_data, '--size', 10240]
    #mysql.vm.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', mysql_data]
Vagrant.configure("2") do |config|

  config.vm.define "backup" do |backup|
    backup.vm.box = "ubuntu/xenial64"
    backup.vm.hostname = 'backup.local'
    
    backup.vm.network :private_network, ip: "10.0.0.2"

    backup.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "backup.local"]
      unless File.exist?("backupdata.vmdk")
        v.customize [ "createmedium", "disk", "--filename", "backupdata.vmdk","--format", "vmdk", "--size", 200 * 1024]
      end
        v.customize [ "storageattach", "backup.local" , "--storagectl", "SCSI", "--port", "4", "--device", "0", "--type", "hdd", "--medium", "backupdata.vmdk"]

    end

    backup.vm.provision 'chef_zero' do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe 'glrl::backup'      
      chef.nodes_path = 'nodes'        
    end
  end

  config.vm.define "mysql" do |mysql|
    mysql.vm.box = "ubuntu/xenial64"
    mysql.vm.hostname = "mysql.local"

    mysql.vm.network :private_network, ip: "10.0.0.1"

    mysql.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--name", "mysql.local"]
      unless File.exist?("mysqldata.vmdk")
        v.customize [ "createmedium", "disk", "--filename", "mysqldata.vmdk","--format", "vmdk", "--size", 20 * 1024]
      end
        v.customize [ "storageattach", "mysql.local" , "--storagectl", "SCSI", "--port", "4", "--device", "0", "--type", "hdd", "--medium", "mysqldata.vmdk"]
    end

    mysql.vm.provision 'chef_zero' do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe 'glrl::mysql'      
      chef.nodes_path = 'nodes'        
    end
  end
  
end