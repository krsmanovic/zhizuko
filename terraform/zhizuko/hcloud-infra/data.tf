# Cloud-init script
data "template_file" "zhizuko_user_data" {
  template = file("${path.module}/templates/cloud-init.yaml")
  vars = {
    server_name = var.server_name
    domain      = var.application_fqdn

    zhizuko_unitfile       = base64encode(data.template_file.zhizuko_systemd_unitfile.rendered)
    zhizuko_linux_password = random_password.zhizuko_linux_password.result
    nginx_config           = base64encode(data.template_file.nginx_conf.rendered)
    cert_contact_email     = var.cert_contact_email

    umbraco_friendly_name = var.umbraco_friendly_name
    umbraco_password      = random_password.umbraco_password.result
    umbraco_email         = var.umbraco_email
    umbraco_db_name       = local.umbraco_db_name

    mssql_sa_password    = random_password.mssql_sa_password.result
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
    mssql_sa_password   = random_password.mssql_sa_password.result
    zhizuko_db_password = random_password.zhizuko_db_password.result
    umbraco_db_name     = local.umbraco_db_name
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
