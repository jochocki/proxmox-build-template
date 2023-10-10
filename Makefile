include .env
export

all: pre packer_ubuntu packer_debian post

pre:
	bash bin/pre.sh

<<<<<<< HEAD
packer_ubuntu:
	packer build -var-file='credentials.pkr.hcl' ubuntu-ci.pkr.hcl

packer_debian:
	packer build -var-file='credentials.pkr.hcl' debian-ci.pkr.hcl
	
=======
packer:
	packer build -var-file='credentials.pkr.hcl' ubuntu-ci.pkr.hcl
>>>>>>> refs/remotes/origin/main

post:
	bash bin/post.sh

install:
	ln -s /opt/build-template/systemd/* /etc/systemd/system/
