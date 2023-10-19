# What's this project about?  

This project builds, configures and maintain cloud-init enabled Linux VMs and transform them into templates on Proxmox hypervisor.

To automate this chain, cloud-init images are used in combination with proxmox CLI and packer.


# How does it work?


1. Service executes the nightly job, which first fetches the latest cloud-init images, then it creates and configures Proxmox VMs.

2. `packer` creates templates from newly prepared VMs and configures the templates with cloud-init defaults (SSH user and public key). 

You can easily customize this and add more cloud-init defaults. 
List of all possible defaults:
https://pve.proxmox.com/wiki/Cloud-Init_Support


If the systemd service fails for any reason, it's configured to trigger the `notify-email@%i.service`. It also sends a notification with `proxmox-mail-forward` on successful build.


# Currently used OSs

* Debian 12 (bookworm)
* AlmaLinux 9 (selinux set to permissive)
* Ubuntu 22.04.3 (Jammy)

## Installation

Installation is intended to be done on the Proxmox host itself, otherwise it won't work.

### Install dependencies

```
apt-get update && apt-get install libguestfs-tools wget vim git unzip
```

### Manually install packer 

Because I'm using token ID/secret as proxmox authentication method, packer must be install manually to attain newer version than proxmox currently supports as default package. New versions support this auth method and also fixes a lot of bugs you may encounter.

https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli

TLDR 
Download the newest version (currently 201.9.4)
wget https://developer.hashicorp.com/packer/downloads#:~:text=Version%3A%201.9.4-,Download,-AMD64

Unzip && move the precompile file
unzip packer*
mv packer /usr/bin/


### Make sure these VM IDs are not used:

8999, 9000, 8000, 7999, 7000, 6999



### Clone the repository

Clone the repository to `/opt`.

```
git clone https://github.com/Ard3ny/proxmox-build-template.git /opt/build-template
cd /opt/build-template
```

### Create token/secret in proxmox

If you don't know how, I've explained it in a full tutorial in my [blog post.](https://blog.thetechcorner.sk/posts/Build-a-cloud-init-enabled-Linux-VM-templates-on-Proxmox-provisioned-by-packer/)

TLDR over CLI 

```
pveum user add kubernetes@pve
pveum acl modify / -user kubernetes@pve -role Administrator
pveum acl modify / -user kubernetes@pve -role PVEAdmin
pveum user token add kubernetes@pve test_id -privsep 0
```

### Configuration

Copy the environment variable files and edit them with your own parameters.

```
cp env .env && cp credentials.pkr.hcl.example credentials.pkr.hcl
vim .env
vim credentials.pkr.hcl
```
### Add packages you want to install

Edit bin/bootstrap* files and add your own packages to be installed.

```
vim bin/bootstrap_deb.sh
vim bin/bootstrap_ubuntu.sh
vim bin/bootstrap_rhel.sh
```

### Setup systemd timers

By default, the build-template service runs each night at 00:15.

```
make install
systemctl daemon-reload
systemctl enable --now build-template.timer
```

## Run it now (for testing)

```
/usr/bin/make -C /opt/build-template
```

# Disclaimer

I've forked this project originally created by https://github.com/mfin/proxmox-build-template
I've fix few bugs, added more cloud-init templates, changed install and auth methods and extended documentation, so big shoutout goes to him.


# Useful links

https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/clone
https://www.libguestfs.org/virt-customize.1.html
