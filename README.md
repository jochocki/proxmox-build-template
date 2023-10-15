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
apt-get update && apt-get install packer libguestfs-tools wget vim git software-properties-common
```
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
```

```
apt-get update && apt-get install packer
```

Make sure these VM IDs are not used:
8999, 9000, 8000, 7999, 7000, 6999


Note: You may want to install packer manually for newer version, which fixed a lot of bugs I've encountered.
https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli

### Clone the repository

Clone the repository to `/opt`.

```
git clone https://github.com/Ard3ny/proxmox-build-template.git /opt/build-template
cd /opt/build-template
```

### Configuration

Copy the environment variable files and edit them with your own parameters.

```
cp env .env && cp credentials.pkr.hcl.example credentials.pkr.hcl
vim .env
vim credentials.pkr.hcl
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
I've just fix few bugs, added more cloud-init templates and extended documentation, so big shoutout goes to him.


# Useful links

https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/clone
https://www.libguestfs.org/virt-customize.1.html