output "server_public_ip" {
  value = hcloud_server.server.ipv4_address
}
