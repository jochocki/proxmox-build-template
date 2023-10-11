#!/usr/bin/env bash

set -e
#------------Alma9----------------------

export RHEL_FRONTEND=noninteractive

hostnamectl 

sudo yum install -y cifs-utils nfs-common open-iscsi lsscsi sg3-utils multipath-tools scsitools

sudo tee /etc/multipath.conf <<-'EOF'
defaults {
    user_friendly_names yes
    find_multipaths yes
}
EOF

sudo cloud-init clean


