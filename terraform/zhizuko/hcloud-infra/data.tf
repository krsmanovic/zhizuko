# Cloud-init script
data "template_file" "zhizuko_user_data" {
  template = file("${path.module}/templates/cloud-init.yaml")
  vars = {
    server_name  = var.server_name
    domain       = var.application_fqdn
    project_name = local.umbraco_project_name

    zhizuko_linux_password = random_password.zhizuko_linux_password.result
    cert_contact_email     = local.smtp_to
    mssql_sa_password      = random_password.mssql_sa_password.result

    umbraco_user_name = var.umbraco_user_name
    umbraco_password  = random_password.umbraco_password.result
    umbraco_email     = local.smtp_to
    umbraco_db_name   = local.umbraco_project_name

    # Render files
    appsettings          = base64encode(data.template_file.umbraco_appsettings.rendered)
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
    umbraco_db_name   = local.umbraco_project_name
  }
}

data "template_file" "db_setup" {
  template = file("${path.module}/templates/db-setup.sql")
  vars = {
    mssql_sa_password   = random_password.mssql_sa_password.result
    zhizuko_db_password = random_password.zhizuko_db_password.result
    umbraco_db_name     = local.umbraco_project_name
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
    zhizuko_db_password = random_password.zhizuko_db_password.result
    umbraco_db_name     = local.umbraco_project_name
    smtp_username       = local.smtp_username
    smtp_password       = local.smtp_password
    smtp_to             = local.smtp_to
  }
}

data "aws_secretsmanager_secret_version" "zhizuko_smtp_settings" {
  secret_id = data.aws_secretsmanager_secret.zhizuko_smtp_settings.id
}

# Externally created secret
data "aws_secretsmanager_secret" "zhizuko_smtp_settings" {
  arn = "arn:aws:secretsmanager:eu-central-1:859638983674:secret:GradimoZajedno/SMTP-vVaLD4"
}