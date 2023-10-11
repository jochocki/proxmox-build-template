#!/usr/bin/env bash

set -e
#------------Ubuntu/debian----------------------


export DEBIAN_FRONTEND=noninteractive

sudo apt-get install -y linux-modules-extra-$(uname -r) cifs-utils nfs-common open-iscsi lsscsi sg3-utils multipath-tools scsitools

hostnamectl

sudo tee /etc/multipath.conf <<-'EOF'
defaults {
    user_friendly_names yes
    find_multipaths yes
}
EOF

sudo cloud-init clean


