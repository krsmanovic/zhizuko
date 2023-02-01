# Cloud-init script
data "template_file" "zhizuko_user_data" {
  template = file("${path.module}/templates/zhizuko-cloud-init.yaml.tpl")
  vars = {
    server_name           = var.server_name
    domain                = var.application_fqdn
    cert_contact_email    = var.cert_contact_email
    umbraco_friendly_name = var.umbraco_friendly_name
    umbraco_password      = random_password.umbraco_password.result
    umbraco_email         = var.umbraco_email
    umbraco_db_name       = var.application_name
    mssql_install_script  = base64encode(data.template_file.mssql_install_script.rendered)
    nginx_config          = base64encode(data.template_file.nginx_conf.rendered)
    zhizuko_unitfile      = base64encode(data.template_file.zhizuko_systemd_unitfile.rendered)
    zhizuko_user_password = random_password.zhizuko_user_password.result
  }
}

data "template_file" "mssql_install_script" {
  template = file("${path.module}/templates/mssql-unattended-install.sh.tpl")
  vars = {
    mssql_sa_password = random_password.mssql_sa_password.result
  }
}

data "template_file" "nginx_conf" {
  template = file("${path.module}/templates/nginx.conf.tpl")
  vars = {
    domain = var.application_fqdn
  }
}

data "template_file" "zhizuko_systemd_unitfile" {
  template = file("${path.module}/templates/zhizuko-systemd-unit-file.tpl")
  vars = {
    app = var.server_name
  }
}
