output "network_id" {
  description = "Network ID"
  value       = hcloud_network.default.id
}

output "floating_ip" {
  description = "Floating IP"
  value       = try(hcloud_floating_ip.default[*].ip_address, "")
}

output "floating_ip_id" {
  description = "Floating IP ID"
  value       = try(hcloud_floating_ip.default[*].id, "")
}