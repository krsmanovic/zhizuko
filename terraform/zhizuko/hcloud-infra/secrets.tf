resource "random_password" "umbraco_password" {
  length  = 20
  special = true
}

resource "random_password" "mssql_sa_password" {
  length  = 20
  special = true
}

resource "random_password" "zhizuko_linux_password" {
  length  = 20
  special = true
}

resource "random_password" "zhizuko_db_password" {
  length  = 20
  special = true
}