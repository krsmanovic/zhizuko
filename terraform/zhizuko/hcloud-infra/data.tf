# Cloud-init script
data "template_file" "zhizuko_user_data" {
  template = file("${path.module}/templates/cloud-init.yaml")
  vars = {
    # General variables
    server_name  = var.server_name
    project_name = local.umbraco_project_name
    # Linux variables
    zhizuko_linux_password = random_password.zhizuko_linux_password.result
    domain                 = var.application_fqdn
    cert_contact_email     = local.smtp_to
    mssql_sa_password      = random_password.mssql_sa_password.result
    # Umbraco variables
    umbraco_user_name = var.umbraco_user_name
    umbraco_password  = random_password.umbraco_password.result
    umbraco_email     = local.smtp_to
    umbraco_db_name   = local.umbraco_db_name
    umbraco_version   = var.umbraco_version
    # Render files
    appsettings = base64encode(data.template_file.umbraco_appsettings.rendered)
    # appsettings_dev      = base64encode(data.template_file.umbraco_appsettings_development.rendered)
    nginx_config         = base64encode(data.template_file.nginx_conf.rendered)
    zhizuko_unitfile     = base64encode(data.template_file.zhizuko_systemd_unitfile.rendered)
    mssql_install_script = base64encode(data.template_file.mssql_install_script.rendered)
    sql_sequence         = base64encode(data.template_file.db_setup.rendered)
  }
}

data "template_file" "mssql_install_script" {
  template = file("${path.module}/templates/mssql-unattended-install.sh")
  vars = {
    mssql_sa_password = random_password.mssql_sa_password.result
    umbraco_db_name   = local.umbraco_db_name
  }
}

data "template_file" "db_setup" {
  template = file("${path.module}/templates/db-setup.sql")
  vars = {
    admin_hash          = data.aws_ssm_parameter.zhizuko_admin_hash.value
    zhizuko_db_password = random_password.zhizuko_db_password.result
    umbraco_db_name     = local.umbraco_db_name
    zhizuko_db_login    = local.umbraco_db_login
    zhizuko_db_user     = local.umbraco_db_user
    umbraco_email       = local.smtp_to
  }
}

data "template_file" "nginx_conf" {
  template = file("${path.module}/templates/nginx.conf")
  vars = {
    domain = var.application_fqdn
  }
}

data "template_file" "zhizuko_systemd_unitfile" {
  template = file("${path.module}/templates/zhizuko.service")
  vars = {
    app = var.application_name
  }
}

data "template_file" "umbraco_appsettings" {
  template = file("${path.module}/templates/appsettings.json")
  vars = {
    server_name = var.server_name
    # database
    zhizuko_db_login    = local.umbraco_db_login
    zhizuko_db_password = random_password.zhizuko_db_password.result
    mssql_sa_password   = random_password.mssql_sa_password.result
    # umbraco
    umbraco_user_name = var.umbraco_user_name
    umbraco_password  = random_password.umbraco_password.result
    umbraco_email     = local.smtp_to
    umbraco_db_name   = local.umbraco_db_name
    # smtp
    smtp_username = local.smtp_username
    smtp_password = local.smtp_password
    smtp_to       = local.smtp_to
  }
}

# Externally created secrets
data "aws_ssm_parameter" "zhizuko_admin_hash" {
  name            = "/uvek-sa-decom/umbraco/admin/hash"
  with_decryption = true
}

data "aws_ssm_parameter" "smtp_email" {
  name            = "/uvek-sa-decom/umbraco/smtp/email"
  with_decryption = true
}

data "aws_ssm_parameter" "smtp_password" {
  name            = "/uvek-sa-decom/umbraco/smtp/password"
  with_decryption = true
}

data "aws_ssm_parameter" "smtp_to" {
  name            = "/uvek-sa-decom/umbraco/smtp/to"
  with_decryption = true
}