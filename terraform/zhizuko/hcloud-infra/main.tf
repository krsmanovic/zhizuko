module "zhizuko_network" {
  source               = "../../modules/hcloud-network"
  private_network_name = var.server_name
  floating_ip_name     = var.server_name
  generic_labels       = merge(local.labels, var.app_specific_labels)
}

module "zhizuko_server" {
  source              = "../../modules/hcloud-server"
  server_image        = var.server_base_image
  server_type         = var.server_type
  server_name         = var.server_name
  network_id          = module.zhizuko_network.network_id
  firewall_ids        = [hcloud_firewall.zhizuko.id]
  ssh_public_key_name = var.ssh_key_name
  user_data           = data.template_file.zhizuko_user_data.rendered
  generic_labels      = merge(local.labels, var.app_specific_labels)
}

resource "hcloud_firewall" "zhizuko" {
  name = "zhizuko-firewall"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0"]
  }
}
