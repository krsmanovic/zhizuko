locals {
  labels = {
    AppName           = "Zhizuko"
    CreationTimestamp = "${formatdate("YYYYMMDDhhmmss", timestamp())}"
    Environment       = "Prod"
    IaC               = "Terraform"
    Organization      = "Uvek-sa-decom"
  }

  umbraco_db_name = "${var.application_name}db"
}
