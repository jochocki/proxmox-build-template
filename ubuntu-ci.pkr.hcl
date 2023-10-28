variable "proxmox_host_node" {
  type    = string
  default = "pve"
}

variable "proxmox_template_name" {
  type    = string
  default = "ubuntu-template"
}

variable "proxmox_api_url" {
  type = string
}

# token/secret auth method 
variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

#If you want to use username/password instead of token
#variable "proxmox_api_username" {
#  type    = string
#  default = "root@pve"
#}

#variable "proxmox_api_password" {
#  type    = string
#  sensitive = true
#}

variable "proxmox_network_bridge" {
  type    = string
  default = "vmbr0"
}

packer {
  required_plugins {
    proxmox = {
      version = " >= 1.0.1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "ubuntu" {
  template_name        = "${var.proxmox_template_name}"
  template_description = "Built at ${timestamp()} by Packer"
  unmount_iso          = true

  iso_url      = "${var.cloud_init_ubuntu_image_url}"
  iso_checksum = "file:${var.cloud_init_ubuntu_image_checksum}"

  os              = "l26"
  cores           = "1"
  memory          = "1024"
  scsi_controller = "virtio-scsi-pci"
  vm_id           = "9000"

  ssh_username = "packer"
  ssh_timeout  = "10m"

  qemu_agent = true

  network_adapters {
    bridge   = "${var.proxmox_network_bridge}"
    vlan_tag = "10"
    model    = "virtio"
  }

  node = "${var.proxmox_host_node}"

  #username/passwort auth method
  #username      = "${var.proxmox_api_username}"
  #password      = "${var.proxmox_api_password}"

  #token ID / secret auth method 
  username = "${var.proxmox_api_token_id}"
  token    = "${var.proxmox_api_token_secret}"

  proxmox_url = "${var.proxmox_api_url}"
}

build {
  sources = ["source.proxmox-iso.ubuntu"]
}