# DDPS demo of the WEB and API-app
This repository builds VM running on VirtualBox using Vagrant. The VM is a demo of the DeiC DDoS Prevention System's WEB-GUI and WEB-API.

### Requiremnts
You need the following installed:

  * [VirtualBox](https://www.virtualbox.org)
  * [Vagrant](https://www.vagrantup.com)

They both work on Windows, MacOS and Linux -- are both free, and easy to install.

To see a demonstration of the WEB-app and the API-app follow the instructions below.

### WEB-app demo
Type: http://127.0.0.1:8080 into your browser.

### API-app demo
Type: http://127.0.0.1:9090 into your browser.


# Short introduction to Vagrant, and how this project is organized
Vagrant is an easy way to manage VM's running on various Hypervisors (VirtualBox) with just text files, and not worrying about the Hypervisor at all.

The configuration of the VM is done from the Vagrantfile in this directory. The Vagrantfile installs an Ubuntu and provisions it from the file provision-vm.sh. The Vagrantfile also forwards TCP port 8080 and 9090 to the VM from localhost on your machine to the dynamic IP of the VM. The Vagrantfile also mounts the directory inside the VM in /vagrant, so all the files in the files/ folder are available inside the VM.

The project contains the following important files and folders:

    $ tree
    ├── README.md
    ├── Vagrantfile
    ├── files
    │   ├── README.md
    │   ├── api-app
    │   │   └── install.sh
    │   ├── db2dps
    │   │   └── install.sh
    │   ├── exabgp
    │   │   └── install.sh
    │   ├── nginx
    │   │   └── install.sh
    │   ├── node
    │   │   └── install.sh
    │   ├── os-patches
    │   │   └── install.sh
    │   ├── pgpool-II
    │   │   └── install.sh
    │   ├── postgresql
    │   │   └── install.sh
    │   └── web-app
    │       └── install.sh
    └── provision-vm.sh

The files/ folders contains all the scripts and files for installing, and configuring all the applications running inside the VM.

The provision-vm.sh is called from the Vagrantfile, and configures all the applications in a specific order.

All services running inside the VM must run on localhost (since the IP of the VM is dynamic), and we use the Vagrantfile to forward them to the VM (TCP port 8080 and 9090).


## Using Vagrant
After you have installed VirtualBox and Vagrant, you can provision a demo VM from this directory (using the Vagrantfile).

** It's important that you standing the the directory containing the Vagrantfile! **

Vagrant has a lot of options, just run `$ vagrant` to see all the options.

### Provision a VM using Vagrant with

    $ vagrant up

The first time you provision it will take a long time, since you need to fetch the Vagrant box image (running Ubuntu) and confiure all the software inside the VM afterwards.

### When Vagrant is done provisioning the VM you can SSH into it with

    $ vagrant ssh

### If you need to reboot the VM use

    $ vagrant reload

Don't reboot the VM from inside the VM! It wont load the Vagrantfile when booting, and mounting /vagrant and portforwarding wont work.

### When you are done, you can halt/shutdown the VirtualBox VM with

    $ vagrant halt

You can also just halt/shutdown the image from inside the VM.

### Continue later with the same VM

    $ cd [This git repo]
    $ vagrant up

Do not start the machine from VirtualBox. Always start the VM using `vagrant up`.

### If you want to start over with a fresh version of the VM (a new provisioning)

    $ cd [This git repo]
    $ vagrant destroy
    $ vagrant up

And a fresh new install is ready for you. All your changes to the old VM is gone!


# Debugging for developers
If you are responsible for mantaining the DDPS-demo VM, the following are nice to know.

### Colors during the Vagrant provisioning
Watch the output when running `$ vagrant up`. Look for anything in the color red (it's an error of some kind). Normal color output is from the Vagrant box image (made by Ubuntu). Yellow color output is from our provisioning of the VM after it has booted.

### Errors during boot
Check the ubuntu-console.log for errors during boot. It will be located in this directory.

### Got root?
When using Vagrant you login as the user vagrant. If you need root access the vagrant user has `sudo` access.

    $ vagrant ssh
    $ sudo bash

And you will have a root shell (bash).

### Check /var/log inside the VM
Make sure to look in /var/log for logfiles if you are having trouble with installing or configuring your application.

    $ vagrant ssh
    $ sudo bash
    $ cd /var/log
    $ ls -lart

Check the newest files, specific application folders or syslog if in doubt.

### Services running inside the VM
If you have a service running inside the VM (postgreSQL, pgpool, NGINX, Node.js apps they MUST run on localhost (127.0.0.1)!

    $ vagrant ssh              # log into the VM
    $ netstat -an |grep tcp    # list all TCP services running inside the VM

Make sure your service is running on: 127.0.0.1 or ::1 (IPv6) and that it is listing on the correct port!

NGINX (and SSH) are the only exceptions to this rule.

### Debug networking issues
How can I see that the VM receives my network traffic, when I type http://127.0.0.1:8080 into my browser?

    $ vagrant ssh                             # log in to the VM
    $ sudo tcpdump -ni enp0s3 tcp port 8080   # tcpdump for traffic on TCP port 8080, change port number if you need another port
    type http://127.0.0.1:8080 into your browser or press reload

You should now see traffic in your tcpdump on the VM. If not check your Vagrantfile and see that the ports you need are forwarded.
