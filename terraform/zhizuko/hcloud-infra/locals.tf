locals {
  labels = {
    AppName           = "Zhizuko"
    CreationTimestamp = "${formatdate("YYYYMMDDhhmmss", timestamp())}"
    IaC               = "Terraform"
  }

  umbraco_project_name = "GradimoZajedno"

  smtp_username = jsondecode(data.aws_secretsmanager_secret_version.zhizuko_smtp_settings.secret_string)["email"]
  smtp_password = jsondecode(data.aws_secretsmanager_secret_version.zhizuko_smtp_settings.secret_string)["password"]
  smtp_to       = jsondecode(data.aws_secretsmanager_secret_version.zhizuko_smtp_settings.secret_string)["to"]
}
