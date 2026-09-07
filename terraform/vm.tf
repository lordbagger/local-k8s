resource "libvirt_volume" "disk" {
  count          = var.vm_count
  name           = "${var.vm_names[count.index]}.qcow2"
  pool           = var.pool_name
  base_volume_id = libvirt_volume.base.id
  size           = var.vm_disk_size_gb * 1024 * 1024 * 1024
  format         = "qcow2"
}

resource "libvirt_cloudinit_disk" "init" {
  count = var.vm_count
  name  = "${var.vm_names[count.index]}-cloudinit.iso"
  pool  = var.pool_name
  user_data = templatefile("${path.module}/cloud-init/user-data.tftpl", {
    hostname       = var.vm_names[count.index]
    ssh_user       = var.ssh_user
    ssh_public_key = trimspace(file(var.ssh_public_key_path))
  })
}

resource "libvirt_domain" "worker" {
  count  = var.vm_count
  name   = var.vm_names[count.index]
  memory = var.vm_memory_mb
  vcpu   = var.vm_vcpu

  cloudinit = libvirt_cloudinit_disk.init[count.index].id

  # Expose a virtio-serial channel for qemu-guest-agent, installed by cloud-init.
  # Gives IP reporting a source beyond the network's DHCP leases.
  qemu_agent = true

  disk {
    volume_id = libvirt_volume.disk[count.index].id
  }

  network_interface {
    network_name   = var.network_name
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
    autoport    = true
  }
}
