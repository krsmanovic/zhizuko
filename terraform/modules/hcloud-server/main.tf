resource "hcloud_server" "server" {
  name        = var.server_name
  image       = var.server_image
  server_type = var.server_type
  location    = var.hcloud_location
  backups     = var.enable_backups
  ssh_keys    = [var.ssh_public_key_name]
  user_data   = var.user_data

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.primary_ip.id
    ipv6_enabled = var.enable_public_ipv6
  }

  labels = merge(var.generic_labels, local.module_labels)

  lifecycle {
    ignore_changes = [
      labels["CreationTimestamp"],
    ]
  }
}

resource "hcloud_server_network" "server_network" {
  network_id = var.network_id
  server_id  = hcloud_server.server.id
}

resource "hcloud_floating_ip_assignment" "main" {
  count          = var.enable_floating_ip ? 1 : 0
  floating_ip_id = var.floating_ip_id
  server_id      = hcloud_server.server.id
}

resource "hcloud_primary_ip" "primary_ip" {
  name          = "${var.server_name}-primary-ip"
  type          = "ipv4"
  assignee_type = "server"
  datacenter    = var.hcloud_datacenter
  auto_delete   = false
  labels        = merge(var.generic_labels, local.module_labels)
}