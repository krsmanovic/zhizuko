resource "random_password" "umbraco_password" {
  length  = 20
  special = true
}

resource "random_password" "mssql_sa_password" {
  length  = 20
  special = true
}