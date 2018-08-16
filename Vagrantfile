# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/xenial64"
    config.vm.hostname = "ddps-demo"

    # Configure http://localhost:8080 to reach the GUI-app on the VM
    config.vm.network :forwarded_port, guest: 8080, host: 8080, id: 'gui'

    # Configure http://localhost:9090 to reach the API-app on the VM
    config.vm.network :forwarded_port, guest: 9090, host: 9090, id: 'api'

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
