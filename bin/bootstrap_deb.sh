#!/usr/bin/env bash

set -e
#------------debian----------------------

export DEBIAN_FRONTEND=noninteractive

#to fix a bug where sometimes lock-frontend is locked and script crashes 
while sudo lsof /var/lib/dpkg/lock-frontend ; do sleep 10; done;


sudo apt-get install -y cifs-utils nfs-common open-iscsi lsscsi sg3-utils multipath-tools scsitools

hostnamectl

sudo tee /etc/multipath.conf <<-'EOF'
defaults {
    user_friendly_names yes
    find_multipaths yes
}
EOF

sudo cloud-init clean


