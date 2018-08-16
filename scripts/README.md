# Scripts folder.
This folder contains all the installation scripts for setting up a VM.

It contains the files below:

    $ tree
    ├── README.md
    ├── install.sh
    └── vm-install.d
        ├── 01-install_patches.sh
        ├── 10-install_postgresql.sh
        ├── 20-install_pgpool.sh
        ├── 30-install_nginx.sh
        ├── 40-install_node.sh
        ├── 50-install_exabgp.sh
        ├── 60-install_db2dps.sh
        ├── 70-install_api-app.sh
        ├── 80-install_web-app.sh
        └── 99-force_reboot.sh


## install.sh file
The install.sh is the script that is called from the Vagrantfile and starts the installation. It executes all the files in the catalog: vm-install.d in order.

## vm-install.d catalog
All the scripts ending with .sh is executed in order inside the VM from the loop-back mount /vagrant

All files needed to configure the application is located in the files/"$application" folder.
