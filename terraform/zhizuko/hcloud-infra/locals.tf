locals {
  labels = {
    AppName           = "Zhizuko"
    CreationTimestamp = "${formatdate("YYYYMMDDhhmmss", timestamp())}"
    Environment       = "Prod"
    IaC               = "Terraform"
    Organization      = "Uvek-sa-decom"
  }
}
