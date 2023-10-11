#!/usr/bin/env bash

set -e

#------------UBUNTU----------------------

TMP_UBUNTU_IMG_NAME="/tmp/ubuntu.qcow2"
TEMPL_UBUNTU_NAME="ubuntu-temp"
VMID_UBUNTU="8999"
MEM_UBUNTU="1024"
DISK_SIZE_UBUNTU="5G"
IP_CONFIG_UBUNTU="ip=10.100.4.240/24,gw=10.100.4.1"

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