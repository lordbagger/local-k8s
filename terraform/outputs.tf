output "worker_ips" {
  description = "Map of VM hostname to its LAN-leased IP address, for adding to hosts.yaml"
  value = {
    for idx, name in var.vm_names :
    name => try(libvirt_domain.worker[idx].network_interface[0].addresses[0], null)
  }
}
