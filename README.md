# DDPS demo of the WEB and API-app
This repository builds VM running on VirtualBox using Vagrant. The VM is a demo of the DeiC DDoS Prevention System's web-gui and web-api.

## Requiremnts
You need the following installed:

  * [VirtualBox](https://www.virtualbox.org)
  * [Vagrant](https://www.vagrantup.com)

They both work on Windows, MacOS and Linux -- are both free, and easy to install.

To see a demonstration of the WEB-app and the API-app follow the instructions below.

## WEB-app demo
Type: http://127.0.0.1:8080 into your browser.

## WEB-app demo
Type: http://127.0.0.1:9090 into your browser.


# Short introduction to Vagrant, and how this project is organized
Vagrant is an easy way to manage VM's running on various Hypervisors (VirtualBox) with text files.

The configuration of the VM is done from the Vagrantfile in this directory. The Vagrantfile installs an Ubuntu and provisions it from the file scripts/install.sh. The Vagrantfile also forwards TCP port 8080 and 9090 to the VM from localhost on your machine to the dynamic IP of the VM. The Vagrantfile also mounts the directory inside the VM in /vagrant, so all the files in the scripts/ and files/ folder are available inside the VM from /vagrant/scripts and /vagrant/files.

The project contains the following folders:

$ tree
├── files
│   ├── api-app
│   ├── db2dps
│   ├── exabgp
│   ├── nginx
│   ├── node
│   ├── pgpool
│   ├── postgresql
│   └── web-app
└── scripts
    └── vm-install.d

The two top folders are scripts/ and files/. The scripts folder contains all the scripts for installing, and configuring all the applications inside the VM. The files folder contains all the files need to configure the applications.

All services running inside the VM must run on localhost (since the IP of the VM is dynamic), and we use the Vagrantfile to forward them to the VM (TCP port 8080 and 9090).


## Using Vagrant
After you have installed VirtualBox and Vagrant, you can provision a demo VM from this directory (using the Vagrantfile).

*** It's important that you standing the the directory containing the Vagrantfile!**

Vagrant has a lot of options, just run `$ vagrant` to see all the options.

### Provision a VM using Vagrant with

    $ vagrant up

### When Vagrant is done provisioning the VM you can SSH into it with

    $ vagrant ssh

### When you are done, you can halt/shutdown the VirtualBox image with

    $ vagrant halt

You can also just halt/shutdown the image from inside the VM.

### Continue later with the same VM, and any change to the VM

    $ cd [This git repo]
    $ vagrant up

### If you want to start over with a fresh version of the VM (new provision)

    $ cd [This git repo]
    $ vagrant destroy
    $ vagrant up

And a fresh new install is ready for you. All your changes to the old VM is gone!
