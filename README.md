# DDPS demo of the WEB and API-app
This repository builds a VM running on VirtualBox using Vagrant. The VM is a demo of the DeiC DDoS Prevention System.

The project is primarily for developers of DDPS, but others are welcome to check it out.

### Requiremnts
You need the following elements installed:

  * [VirtualBox](https://www.virtualbox.org)
  * [Vagrant](https://www.vagrantup.com)

They both work on Windows, MacOS and Linux -- are both free, and easy to install.

#### Demo time
To see a demonstration, just type the following into a modern browser:

http://ddps.deic.dk

**We need a default username and password!?**


# Short introduction to Vagrant, and how this project is organized
Vagrant is an easy way to manage VM's running on various Hypervisors (VirtualBox) with just text files, and not worrying about the Hypervisor at all.

The configuration of the VM is done from the Vagrantfile in this directory. The Vagrantfile installs an Ubuntu and provisions it from the file: provision-vm.sh. The Vagrantfile configures a private network interface, with IP: 130.225.242.205 which ddps.deic.dk (and www.ddps.deic.dk) already resolves too. The Vagrantfile also mounts this directory inside the VM in /vagrant, so all the files in the files/ folder are available inside the VM in /vagrant/files.

The project contains the following important files and folders:

    $ tree
    ├── Vagrantfile
    ├── files
    │   ├── README.md
    │   ├── api-app
    │   │   └── install.sh
    │   ├── db2dps
    │   │   ├── install.sh
    │   ├── exabgp
    │   │   ├── install.sh
    │   ├── nginx
    │   │   └── install.sh
    │   ├── node
    │   │   └── install.sh
    │   ├── os-patches
    │   │   └── install.sh
    │   ├── os-utilities
    │   │   └── install.sh
    │   ├── pgpool-II
    │   │   ├── configure.sh
    │   │   ├── install.sh
    │   │   └── post_install.sh
    │   ├── postgresql
    │   │   ├── configure.sh
    │   │   ├── install.sh
    │   ├── vagrant-report
    │   │   └── check-services.sh
    │   └── web-app
    │       └── install.sh
    └── provision-vm.sh

The files/ folder contains all the scripts and files for installing and configuring all the applications running inside the VM. Each application have their own catalog. There are more files in the folders than listed above.

The provision-vm.sh is called from the Vagrantfile, and installs and configures all the applications in a specific order.

All services running inside the VM must run on localhost (127.0.0.1). Only NGINX is allowed to listen on 0.0.0.0, since it functions as a reverse proxy for the web applications.


## Using Vagrant
After you have installed VirtualBox and Vagrant, you can provision a demo DDPS VM from this directory (using the Vagrantfile).

**It's important that you are standing in the directory containing the Vagrantfile!**

Vagrant has a lot of options, just run `$ vagrant` to see all the options.

### Provision a VM using Vagrant with

    $ vagrant up

The first time you provision it will take a long time, since you need to fetch the Vagrant box image (running Ubuntu) and configure all the software inside the VM afterwards.

### When Vagrant is done provisioning the VM you can SSH into it with

    $ vagrant ssh

### If you need to reboot the VM use

    $ vagrant reload

Don't reboot the VM from inside the VM! It wont load the Vagrantfile when booting, and mounting /vagrant and portforwarding wont work!

### When you are done, you can halt/shutdown the VirtualBox VM with

    $ vagrant halt

You can also just halt/shutdown the image from inside the VM.

### Continue later with the same VM

    $ cd [This git repo]
    $ vagrant up

Do not start the machine from VirtualBox. Always start the VM using `vagrant up`, or the Vagrantfile wont load!

### If you want to start over with a fresh version of the VM (a new provisioning)

    $ cd [This git repo]
    $ vagrant destroy     # use `vagrant destroy -f` if you don't want confirmation
    $ vagrant up

And a fresh new install is ready for you. All your changes to the old VM is gone!

Vagrant -- for some reason -- does **NOT** delete routes from your OS to VM's when running `vagrant halt` or `vagrant destory`. You have to remove them yourself! On MacOS use:

    $ sudo route delete 130.225.242.200/29 && sudo route delete 172.22.86.8/30 

### If you need to quickly reprovisioin for testing

    $ vagrant provision

It will rerun all the provision-vm.sh. Please make sure that all install scripts are idempotent.


# Debugging for developers
If you are responsible for maintaining the DDPS-demo VM, the following are nice to know.

### Colors during the Vagrant provisioning
Watch the output when running `$ vagrant up`. Look for the colors in your terminal.

  * NORMAL: Output from the Vagrant box image (made by Ubuntu).
  * GREEN:  Output from provisioning the VM (all the install and configure scritps).
  * RED:    Error of some kind (please fix)!

### Errors during boot
Check the ubuntu-console.log for errors during boot. It will be located in this directory.

### Got root?
When using Vagrant you login as the user vagrant. If you need root access the vagrant user has `sudo` access.

    $ vagrant ssh
    $ sudo bash

And you will have a root shell (bash).

### Check /var/log inside the VM
Make sure to look in /var/log for logfiles in the VM.

    $ vagrant ssh
    $ sudo bash
    $ cd /var/log
    $ ls -lart

Check the newest files, specific application folders or syslog if in doubt.

### Services running inside the VM
If you have a service running inside the VM (postgreSQL, pgpool, Node.js apps they MUST run on localhost (127.0.0.1)!

    $ vagrant ssh              # log into the VM
    $ netstat -an |grep tcp    # list all TCP services running inside the VM

Make sure your service is running on: 127.0.0.1 **NOT** ::1 (IPv6) - and that it is listing on the correct port!

NGINX (and SSH) are the only exceptions to this rule. NGINX must redirect traffic to the WEB and API-apps. Don't change SSH-settings or `vagrant ssh` might not work. Pgpool-II can be ignored, since we only run one VM for the demo.

### Debug network issues
How can I see that the VM receives my network traffic? 

When typing http://ddps.deic.dk into a browser, and you want to verify that the VM receives the traffic:

    $ vagrant ssh                          # log in to the VM
    $ sudo tcpdump -ni enp0s3 tcp port 80  # tcpdump for traffic on TCP port 80, change port number if you need another port
    type http://ddps.deic.dk into your browser or press reload

You should now see traffic in your tcpdump on the VM. If not check your Vagrantfile and see if the ports you need are forwarded.

You can also check that the VM correct forwards ports on localhost with.

    $ vagrant ssh          # log in to the VM
    $ sudo tcpdump -ni lo  # tcpdump all traffic on localhost

The NGINX accepts traffic to the domain ddps.deic.dk and www.ddps.deic.dk, and the configuration forwards incomming traffic like so:

    - http://ddps.deic.dk      -> 127.0.0.1:8686
    - http://ddps.deic.dk:8080 -> 127.0.0.1:8686
    - http://ddps.deic.dk:9090 -> 127.0.0.1:9696

Traffic to https:// is redirected to http:// since we normally handle SSL offloading on our load balancers.

## Vagrant specific issues

### Debug Vagrant
If you need more debug output from Vagrant (on Linux and MacOS).

    $ vagrant up --debug                  # debug output to screen
    $ vagrant up --debug &> vagrant.log   # debug output to vagrant.log file

On Windows.

    $ vagrant up --debug 2>&1 | Tee-Object -FilePath ".\vagrant.log"

### Working with Vagrant Box images
Instead of building a virtual machine from scratch, which would be a slow and tedious process, Vagrant uses a base image to quickly clone a virtual machine. The boxes are located in ~/.vagrant.d/boxes - but you can use `vagrant` to list, update and remove them:

    - List all Vagrant Box images:
      $ vagrant box list

    - Update all Vagrant Box images:
      $ vagrant box update

    - Remove old Vagrant Box images:
      $ vagrant box prune

    - See all options for working with Vagrant Box images:
      $ vagrant box

### Update Vagrant plugins

    $ vagrant plugin update

### Vagrant version, will also tell if you need to update Vagrant

    $ vagrant version
