# Files folder.
This folder contains all the files we need for setting up a VM. Each application has it's own folder, where all the files for setting up to application are located.

It contains the directories below:

    $ tree
    ├── api-app
    ├── db2dps
    ├── exabgp
    ├── nginx
    ├── node
    ├── os-patches
    ├── pgpool-II
    ├── postgresql
    └── web-app

The provision script provision-vm.sh controls which applications are installed and configured first. The order matters! 

Each folder must contain an install.sh bash-script for installing and configuring the application. Please check the requirements for your application are meet, before installing/configuring the application.

For instance pgpool-II requires postgresql, so the postgresql/install.sh must come before pgpool-II/install.sh in the provision-vm.sh and the pgpool-II/install.sh should check that postgresql is installed and configured correctly before installing and configuring.
