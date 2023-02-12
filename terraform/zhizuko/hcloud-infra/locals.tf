locals {
  labels = {
    AppName           = "Zhizuko"
    CreationTimestamp = "${formatdate("YYYYMMDDhhmmss", timestamp())}"
    IaC               = "Terraform"
  }
  # Umbraco
  umbraco_project_name = "zhizuko"
  umbraco_db_name      = "${local.umbraco_project_name}db"
  umbraco_db_login     = "${local.umbraco_project_name}login"
  umbraco_db_user      = "${local.umbraco_project_name}user"
  # SMTP
  smtp_username = data.aws_ssm_parameter.smtp_email.value
  smtp_password = data.aws_ssm_parameter.smtp_password.value
  smtp_to       = data.aws_ssm_parameter.smtp_to.value
}
