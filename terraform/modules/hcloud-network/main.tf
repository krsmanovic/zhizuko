resource "hcloud_network" "default" {
  name     = var.private_network_name
  ip_range = var.private_ip_range

  labels = merge(var.generic_labels, local.module_labels)

  lifecycle {
    ignore_changes = [
      labels["CreationTimestamp"],
    ]
  }
}

resource "hcloud_network_subnet" "default" {
  network_id   = hcloud_network.default.id
  type         = "server"
  network_zone = var.private_network_zone
  ip_range     = var.private_ip_range
}

resource "hcloud_floating_ip" "default" {
  count         = var.enable_floating_ip ? 1 : 0
  type          = "ipv4"
  home_location = var.hcloud_location
  name          = var.floating_ip_name

  labels = merge(var.generic_labels, local.module_labels)

  lifecycle {
    ignore_changes = [
      labels["CreationTimestamp"],
    ]
  }
}