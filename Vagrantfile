# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/xenial64"
    config.vm.hostname = "ddps-demo"

    # Configure private network in VM for the public IP for ddps.deic.dk
    config.vm.network "private_network", ip: "130.225.242.205"

    # Should only be used if you are a DeiC employee, and working from the office
    config.vm.network "private_network", ip: "172.22.86.10"

    # Mount the current folder in /vagrant inside the VM
    config.vm.synced_folder ".", "/vagrant"

    # Update VM resources below as needed
    config.vm.provider :virtualbox do |vb|
        vb.name = "ddps-demo"
        vb.memory = 2048
        vb.cpus = 1
        vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
    end

    # Use the install script provision-vm.sh to provision the VM
    config.vm.provision "shell", path: "provision-vm.sh"
end
