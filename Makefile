include .env
export

all: pre packer_ubuntu packer_debian packer_alma9 post

pre:
	bash bin/pre.sh

packer_ubuntu:
	packer build -var-file='credentials.pkr.hcl' ubuntu-ci.pkr.hcl

packer_debian:
	packer build -var-file='credentials.pkr.hcl' debian-ci.pkr.hcl

packer_alma9:
	packer build -var-file='credentials.pkr.hcl' alma9-ci.pkr.hcl

post:
	bash bin/post.sh

install:
	ln -s /opt/build-template/systemd/* /etc/systemd/system/
