#! /usr/bin/env bash
#
#   Copyright 2017, DeiC, Niels Thomas Haugård
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

DEB="db2dps_1.0-164.deb"

TMPFILE=`tempfile`
MYNAME=`basename $0`
export PATH=$PATH:/opt/db2dps/bin:/opt/mkiso/bin:/opt/pgpool2/bin
export DEBIAN_FRONTEND=noninteractive

ME=`realpath $0`
MYDIR=`dirname $ME`

export LANGUAGE="C"
export LANG="C"
export LC_ALL="C"
export LC_CTYPE="C"

#
# functions
#
function savefile()
{
	if [ ! -f "$1" ]; then
		echo "$MYNAME: program error in function savefile, file '$1' not found"
		exit 0
	fi
	if [ ! -f "$1".org ]; then
		cp "$1" "$1".org
	fi
}

function apply_config_to_opt_db2dps()
{
    # /opt/db2dps/etc
    # test -f /opt/db2dps/etc/db.ini     || /bin/cp $RESTORE_SRC_DIR/opt_db2dps_etc/db.ini /opt/db2dps/etc
    # test -f /opt/db2dps/etc/fnmcfg.ini || /bin/cp $RESTORE_SRC_DIR/opt_db2dps_etc/fnmcfg.ini /opt/db2dps/etc

    envsubst < $MYDIR/db.ini.SH     > /opt/db2dps/etc/db.ini
    envsubst < $MYDIR/fnmcfg.ini.SH > /opt/db2dps/etc/fnmcfg.ini

    test -d /opt/db2dps/etc/ssh || mkdir /opt/db2dps/etc/ssh
    test -f /opt/db2dps/etc/ssh/id_rsa || ssh-keygen -t rsa -b 4096 -f  /opt/db2dps/etc/ssh/id_rsa -N ""
    test -d /root/.ssh || mkdir /root/.ssh && chmod 700 /root/.ssh

    grep -q "`cat /opt/db2dps/etc/ssh/id_rsa.pub`" /root/.ssh/authorized_keys || cat /opt/db2dps/etc/ssh/id_rsa.pub >> /root/.ssh/authorized_keys

    # make known_hosts
    HOSTLIST=`sed '/^hostlist/!d; s/.*=//; s/^[ \t]*//' /opt/db2dps/etc//db.ini`
    # assume same user
    for H in ${HOSTLIST}
    do
        RES=`echo "whoami" | ssh -qt -o ConnectTimeout=5 -o StrictHostKeyChecking=no $H -i /opt/db2dps/etc/ssh/id_rsa 2>/dev/null`
        case $RES in
            "root")   :
                ;;
            *)      echo "ssh $H failed:"
                    echo "whoami" | ssh -qt -o ConnectTimeout=5 -o StrictHostKeyChecking=no $H -i /opt/db2dps/etc/ssh/id_rsa 
            ;;
        esac
    done
}

function add_group_and_user()
{
    echo "installing ddpsadm user .... "
    getent passwd ddpsadm > /dev/null 2>&1  >/dev/null || adduser --home /home/ddpsadm --shell /bin/bash --gecos "DDPS admin" --ingroup staff --disabled-password ddpsadm

    echo "adding sftpgroup .... "
    if grep -q sftpgroup /etc/group
    then
         :
    else
        addgroup --system sftpgroup
    fi

    if [ -f /home/sftpgroup/newrules/.ssh/authorized_keys ]; then
        chattr -i /home/sftpgroup/newrules/.ssh/authorized_keys /home/sftpgroup/newrules/.ssh/  >/dev/null 2>&1
        rm -fr /home/sftpgroup/                                                                 >/dev/null 2>&1
        userdel -r newrules                                                                     >/dev/null 2>&1
        echo "removed existing user newrules"
    fi

    mkdir /home/sftpgroup; chown root:root /home/sftpgroup

    echo "setting up sftp user for fastnetmon .... "
    getent passwd newrules >/dev/null 2>&1 >/dev/null || useradd -m -c "DDPS rules upload" -d /home/sftpgroup/newrules/ -s /sbin/nologin newrules
    usermod -G sftpgroup newrules
    usermod -p '*'       newrules

    chmod 755          /home/sftpgroup /home/sftpgroup/newrules/
    mkdir -p           /home/sftpgroup/newrules/.ssh
    chmod 700          /home/sftpgroup/newrules/.ssh
    chown -R root:root /home/sftpgroup /home/sftpgroup/newrules/

    test -d /home/sftpgroup/newrules/upload || mkdir /home/sftpgroup/newrules/upload
    chown newrules:newrules /home/sftpgroup/newrules/upload
    chmod 777 /home/sftpgroup/newrules/upload

    echo "permissions for /home/sftpgroup has been set carefully, dont change"
    echo "use chattr to lock / unlock /home/sftpgroup/newrules/.ssh/authorized_keys"

    chattr -i /home/sftpgroup/newrules/.ssh/
    if [ -f /home/sftpgroup/newrules/.ssh/authorized_keys ]; then
        chattr -i /home/sftpgroup/newrules/.ssh/authorized_keys
    fi
    # this is a dummy key
    cat << EOF | tr -d '\n' > /home/sftpgroup/newrules/.ssh/authorized_keys
ssh-ed25519 AAAAC3NIamAdummyKeyJustToSeIfaScriptWorkspeRsmMT6zzZ154ligQXBF8zHsgS root@00:25:90:46:c2:fe-fastnetmon2.deic.dk
EOF
    chown -R newrules:newrules /home/sftpgroup/newrules/.ssh
    chattr +i /home/sftpgroup/newrules/.ssh   /home/sftpgroup/newrules/.ssh/*

    echo "dummy key added to /home/sftpgroup/.ssh/authorized_keys"

    echo "Append /opt/db2dps/bin and /opt/mkiso/bin to PATH ... "
    echo "PATH=\$PATH:/opt/db2dps/bin:/opt/mkiso/bin" > /etc/profile.d/ddps.sh 
    chmod 644 /etc/profile.d/ddps.sh
    chown root:root /etc/profile.d/ddps.sh
}

function modify_sudoers()
{
    echo "$0: setting sudo without password ... "
    echo '%sudo ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/sudogrp
    chmod 0440 /etc/sudoers.d/sudogrp

    echo "$0: modify /etc/sudoers so /opt/db2dps/bin and /opt/mkiso/bin is in PATH "
    sed 's%.*secure_path.*%Defaults secure_path="/bin:/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/opt/db2dps/bin:/opt/mkiso/bin:/opt/pgpool2/bin"%' /etc/sudoers > /tmp/sudoers
    /bin/mv /tmp/sudoers /etc/sudoers
    chmod  0440 /etc/sudoers 
    chown root:root /etc/sudoers
}


function modify_sshd_config()
{
    # root has no pw, enable ssh login
    echo "enabling password less ssh root login ... "   
    echo "disabling password ssh login ... "
    echo "adding sftp group ... "
    usermod -p '*' root

    if [ ! -f /etc/ssh/sshd_config.org ];
    then
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config.org
    fi

    (
    sed '
       /^AllowTcpForwarding/d;
      s/^ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/;
      s/^#[ \t]*PasswordAuthentication[ \t]yes*/PasswordAuthentication no/;
      s/^PasswordAuthentication.*/PasswordAuthentication no/;
      s/^UsePAM.*/UsePAM no/;
      s/\(X11Forwarding.*\)/AllowTcpForwarding yes\n\1/' < /etc/ssh/sshd_config.org
    cat << EOF
    Match Group sftpgroup
        # Force the connection to use SFTP and chroot to the required directory.
        ForceCommand internal-sftp
        ChrootDirectory %h
        # Disable tunneling, authentication agent, TCP and X11 forwarding.
        PermitTunnel no
        AllowAgentForwarding no
        AllowTcpForwarding no
        X11Forwarding no
EOF
    ) > /etc/ssh/sshd_config
    chmod 0644 /etc/ssh/sshd_config
    chown root:root /etc/ssh/sshd_config
    service ssh restart
}

function install_db2dps_pkg()
{
    export DEBIAN_FRONTEND=noninteractive
	echo "$0: installing package db2dps ... "

    ( 
        if [ -e ${MYDIR}/${DEB} ]; then
            echo installing ${DEB} ...
        else
            echo "${MYDIR}/${DEB} not found, see line 196 in $0"
            exit 0
        fi

        echo "reading and installing dependencies"
        apt-get install -y `dpkg -I ${MYDIR}/${DEB} |sed '/Depends:/!d; s/Depends://; s/,//g'` > /dev/null && echo "done successfully"
        dpkg -i ${MYDIR}/${DEB} && echo "done successfully"
    )
}

function main()
{
    # check on how to suppress newline (found in an Oracle installation script ca 1992)
    echo="/bin/echo"
    case ${N}$C in
        "") if $echo "\c" | grep c >/dev/null 2>&1; then
            N='-n'
        else
            C='\c'
        fi ;;
    esac

    #
    # Process arguments
    #
    while getopts v opt
    do
    case $opt in
        v)  VERBOSE=TRUE
        ;;
        *)  echo "usage: $0 [-v]"
            exit
        ;;
    esac
    done
    shift `expr $OPTIND - 1`

    . $MYDIR/vars.SH

    add_group_and_user
    modify_sudoers 
    modify_sshd_config 

    install_db2dps_pkg
    apply_config_to_opt_db2dps

    exit 0
}


################################################################################
#
################################################################################

main $*

exit 0
