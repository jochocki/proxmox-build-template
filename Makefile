include .env
export

all: pre packer post

pre:
	bash bin/pre.sh

packer:
	packer build -var-file='credentials.pkr.hcl' ubuntu-ci.pkr.hcl

post:
	bash bin/post.sh

install:
	ln -s /opt/build-template/systemd/* /etc/systemd/system/
