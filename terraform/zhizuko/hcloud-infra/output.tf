output "umbraco_password" {
  value       = random_string.umbraco_password.result
  description = "Password for umbraco user"
}

output "mssql_sa_password" {
  value       = random_string.mssql_sa_password.result
  description = "MSSQL SA (System Administrator) password"
}


output "floating_ip" {
  value       = try(module.zhizuko_network.floating_ip, "")
  description = "Server public floating IPV4 address"
}

output "server_public_ip" {
  value       = module.zhizuko_server.server_public_ip
  description = "Server public IPV4 address"
}
