terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "base" {
  name   = "debian-13-base.qcow2"
  pool   = var.pool_name
  source = var.debian_cloud_image_url
  format = "qcow2"

  # libvirt does not store the download source in the volume XML, so the
  # provider always reads `source` back as empty. Without this, an imported
  # base volume shows a permanent diff that forces a needless re-download.
  lifecycle {
    ignore_changes = [source]
  }
}
