variable "vm_count" {
  description = "Number of worker VMs to create"
  type        = number
  default     = 3
}

variable "vm_names" {
  description = "Hostnames for the worker VMs, one per instance"
  type        = list(string)
  default     = ["nilfheim", "jotunheim", "vanaheim"]
}

variable "vm_memory_mb" {
  description = "Memory per VM, in MiB"
  type        = number
  default     = 4096
}

variable "vm_vcpu" {
  description = "vCPUs per VM"
  type        = number
  default     = 4
}

variable "vm_disk_size_gb" {
  description = "Root disk size per VM, in GiB"
  type        = number
  default     = 50
}

variable "network_name" {
  description = "Name of the pre-existing libvirt network the VMs attach to. 'default' is the built-in NAT network on virbr0 (192.168.122.0/24). Must already exist on the host; Terraform does not create it."
  type        = string
  default     = "default"
}

variable "ssh_user" {
  description = "Username created on each VM"
  type        = string
  default     = "sindri"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key installed for ssh_user"
  type        = string
  default     = "/home/erikbagger/.ssh/sindri.pub"
}

variable "debian_cloud_image_url" {
  description = "URL of the Debian 13 (Trixie) generic cloud qcow2 image"
  type        = string
  default     = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
}

variable "pool_name" {
  description = "Name of the pre-existing libvirt storage pool backing these VMs. Must already exist on the host; Terraform does not create it."
  type        = string
  default     = "k8s-workers"
}
