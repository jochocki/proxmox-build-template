all: packer_init_ubuntu packer_ubuntu

pre:
	bash bin/pre.sh

packer_init_alma9:
	packer init --upgrade alma9-ci.pkr.hcl 

packer_init_ubuntu:
	packer init --upgrade ubuntu-ci.pkr.hcl 

packer_init_debian:
	packer init --upgrade debian-ci.pkr.hcl 

packer_ubuntu:
	packer build -var-file='credentials.pkr.hcl' ubuntu-ci.pkr.hcl

packer_debian:
	packer build -var-file='credentials.pkr.hcl' debian-ci.pkr.hcl

packer_alma9:
	packer build -var-file='credentials.pkr.hcl' alma9-ci.pkr.hcl

post:
	bash bin/post.sh

install:
	ln -sf /opt/build-template/systemd/* /etc/systemd/system/
