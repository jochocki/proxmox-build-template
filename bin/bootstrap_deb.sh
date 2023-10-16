#!/usr/bin/env bash

set -e
#------------debian----------------------

export DEBIAN_FRONTEND=noninteractive

#to fix a bug where sometimes lock-frontend is locked and script crashes 
while sudo lsof /var/lib/dpkg/lock-frontend ; do sleep 10; done;


#put your packages here
#sudo apt-get install -y vim git

hostnamectl

sudo cloud-init clean


