variable "proxmox_host_node" {
  type    = string
  default = "pve"
}

variable "proxmox_source_template" {
  type    = string
  default = "debian-temp"
}

variable "proxmox_template_name" {
  type    = string
  default = "debian-template"
}

variable "proxmox_api_url" {
  type    = string
}

#Waiting for newer version of proxmox packer to loggin via token/secret
#variable "proxmox_api_token_id" {
#  type    = string
#}

#variable "proxmox_api_token_secret" {
#    type = string
#    sensitive = true
#}

variable "proxmox_api_username" {
  type    = string
  default = "root@pve"
}

variable "proxmox_api_password" {
  type    = string
  sensitive = true
}

variable "proxmox_network_bridge" {
  type    = string
  default = "vmbr0"
}

source "proxmox-clone" "debian" {
  insecure_skip_tls_verify = true
  full_clone = false

  template_name = "${var.proxmox_template_name}"
  template_description = "Built at ${timestamp()} by Packer"
  clone_vm      = "${var.proxmox_source_template}"

  os              = "l26"
  cores           = "1"
  memory          = "1024"
  scsi_controller = "virtio-scsi-pci"
  vm_id           = "8000"

  ssh_username = "packer"
  qemu_agent = true

  network_adapters {
    bridge = "${var.proxmox_network_bridge}"
    model  = "virtio"
  }

  node          = "${var.proxmox_host_node}"
  username      = "${var.proxmox_api_username}"
  password      = "${var.proxmox_api_password}"
  #token         = "${var.proxmox_api_token_secret}"
  proxmox_url   = "${var.proxmox_api_url}"
}

build {
  sources = ["source.proxmox-clone.debian"]

  provisioner "shell" {
    script = "bin/bootstrap_deb.sh"
  }
}