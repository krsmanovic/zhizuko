resource "random_password" "umbraco_password" {
  length      = 20
  min_lower   = 2
  min_numeric = 2
  min_special = 2
  min_upper   = 2
}

resource "random_password" "mssql_sa_password" {
  length      = 20
  min_lower   = 2
  min_numeric = 2
  min_special = 2
  min_upper   = 2
}

resource "random_password" "zhizuko_linux_password" {
  length      = 20
  min_lower   = 2
  min_numeric = 2
  min_special = 2
  min_upper   = 2
  # create cloud-init friendly password
  special          = true
  override_special = "$(%&!=+@"
}

resource "random_password" "zhizuko_db_password" {
  length      = 20
  min_lower   = 2
  min_numeric = 2
  min_special = 2
  min_upper   = 2
}