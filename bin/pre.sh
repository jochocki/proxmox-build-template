#!/usr/bin/env bash

set -e
#------------UBUNTU----------------------

TMP_UBUNTU_IMG_NAME="/tmp/ubuntu.qcow2"
TEMPL_UBUNTU_NAME="ubuntu-temp"
VMID_UBUNTU="8999"
MEM_UBUNTU="1024"
DISK_SIZE_UBUNTU="5G"
IP_CONFIG_UBUNTU="ip=10.100.4.240/24,gw=10.100.4.1"
#if you want DHCP
#IP_CONFIG_UBUNTU="ip=dhcp"


wget -O $TMP_UBUNTU_IMG_NAME $CLOUD_INIT_UBUNTU_IMAGE_URL

virt-customize --install qemu-guest-agent -a $TMP_UBUNTU_IMG_NAME

qm destroy 9000 --purge || echo "Template already missing."
qm destroy 8999 --purge || echo "VM already missing."

qm create $VMID_UBUNTU --name $TEMPL_UBUNTU_NAME --memory $MEM_UBUNTU --net0 virtio,bridge=$PKR_VAR_proxmox_network_bridge
qm importdisk $VMID_UBUNTU $TMP_UBUNTU_IMG_NAME $PVE_DISK_STORAGE
qm set $VMID_UBUNTU --scsihw virtio-scsi-pci --scsi0 $PVE_DISK_STORAGE:vm-$VMID_UBUNTU-disk-0
qm set $VMID_UBUNTU --ide2 $PVE_DISK_STORAGE:cloudinit
qm set $VMID_UBUNTU --boot c --bootdisk scsi0
qm set $VMID_UBUNTU --serial0 socket --vga serial0
qm set $VMID_UBUNTU --ipconfig0 $IP_CONFIG_UBUNTU
qm resize $VMID_UBUNTU scsi0 $DISK_SIZE_UBUNTU

qm template $VMID_UBUNTU

rm $TMP_UBUNTU_IMG_NAME


#------------Debian----------------------

TMP_DEBIAN_IMG_NAME="/tmp/debian.qcow2"
TEMPL_DEBIAN_NAME="debian-temp"
VMID_DEBIAN="7999"
MEM_DEBIAN="1024"
DISK_SIZE_DEBIAN="5G"
IP_CONFIG_DEBIAN="ip=10.100.4.239/24,gw=10.100.4.1"
#Change to your IPs or use DHCP if you want
#IP_CONFIG_DEBIAN="ip=dhcp"

wget -O $TMP_DEBIAN_IMG_NAME $CLOUD_INIT_DEBIAN_IMAGE_URL

virt-customize --install qemu-guest-agent -a $TMP_DEBIAN_IMG_NAME

qm destroy 8000 --purge || echo "Template already missing."
qm destroy 7999 --purge || echo "VM already missing."

qm create $VMID_DEBIAN --name $TEMPL_DEBIAN_NAME --memory $MEM_DEBIAN --net0 virtio,bridge=$PKR_VAR_proxmox_network_bridge
qm importdisk $VMID_DEBIAN $TMP_DEBIAN_IMG_NAME $PVE_DISK_STORAGE
qm set $VMID_DEBIAN --scsihw virtio-scsi-pci --scsi0 $PVE_DISK_STORAGE:vm-$VMID_DEBIAN-disk-0
qm set $VMID_DEBIAN --ide2 $PVE_DISK_STORAGE:cloudinit
qm set $VMID_DEBIAN --boot c --bootdisk scsi0
qm set $VMID_DEBIAN --serial0 socket --vga serial0
qm set $VMID_DEBIAN --ipconfig0 $IP_CONFIG_DEBIAN
qm resize $VMID_DEBIAN scsi0 $DISK_SIZE_DEBIAN

qm template $VMID_DEBIAN

rm $TMP_DEBIAN_IMG_NAME

#------------Alma9----------------------

TMP_ALMA_IMG_NAME="/tmp/alma9.qcow2"
TEMPL_ALMA_NAME="alma9-temp"
VMID_ALMA="6999"
MEM_ALMA="1024"
DISK_SIZE_ALMA="15G"
IP_CONFIG_ALMA="ip=10.100.4.238/24,gw=10.100.4.1"
#Change to your IPs or use DHCP if you want
#IP_CONFIG_DEBIAN="ip=dhcp"

wget -O $TMP_ALMA_IMG_NAME $CLOUD_INIT_ALMA_IMAGE_URL

#selinux needs to be disabled otherwise packer wont ssh
virt-customize --install qemu-guest-agent  --run-command "sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config" -a $TMP_ALMA_IMG_NAME


qm destroy 7000 --purge || echo "Template already missing."
qm destroy 6999 --purge || echo "VM already missing."

qm create $VMID_ALMA --name $TEMPL_ALMA_NAME --memory $MEM_ALMA --net0 virtio,bridge=$PKR_VAR_proxmox_network_bridge
qm importdisk $VMID_ALMA $TMP_ALMA_IMG_NAME $PVE_DISK_STORAGE
qm set $VMID_ALMA --scsihw virtio-scsi-pci --scsi0 $PVE_DISK_STORAGE:vm-$VMID_ALMA-disk-0
qm set $VMID_ALMA --ide2 $PVE_DISK_STORAGE:cloudinit
qm set $VMID_ALMA --boot c --bootdisk scsi0
qm set $VMID_ALMA --serial0 socket --vga serial0

#because of kernel panics bug cpu has to be host (issue with proxmox and rhel 9 based systems)
qm set $VMID_ALMA --cpu host

qm set $VMID_ALMA --ipconfig0 $IP_CONFIG_ALMA
qm resize $VMID_ALMA scsi0 $DISK_SIZE_ALMA
qm template $VMID_ALMA

rm $TMP_ALMA_IMG_NAME
