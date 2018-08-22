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
    ├── os-utilities
    ├── pgpool-II
    ├── postgresql
    ├── vagrant-report
    └── web-app

The provision script provision-vm.sh (called from the Vagrantfile) controls which applications are installed and configured first. The order matters! 

Each folder contains an install.sh bash-script for installing. Some applications require an additional configure.sh script to configure the application afterwards. Please check that the requirements for your application are meet, before installing/configuring the application. So the scripts can be run multiple times.

For instance pgpool-II requires postgresql, so the postgresql/install.sh must come before pgpool-II/install.sh in the provision-vm.sh and the pgpool-II/install.sh should check that postgresql is installed and configured correctly before installing and configuring.

In the folder vagrant-report/ there is a: check-services.sh script that runs last. Please run a check that your service is running correctly, so the user running `vagrant up` can easily see that all services are running correctly.
