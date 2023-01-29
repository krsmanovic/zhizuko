# Cloud-init script
data "template_file" "zhizuko_user_data" {
  template = file("${path.module}/templates/zhizuko-cloud-init.yaml.tpl")
  vars = {
    server_name           = var.server_name
    umbraco_friendly_name = var.umbraco_friendly_name
    umbraco_password      = random_password.umbraco_password.result
    umbraco_email         = var.umbraco_email
    umbraco_db_name       = var.application_name
    mssql_install_script  = base64encode(data.template_file.mssql_install_script.rendered)
  }
}

data "template_file" "mssql_install_script" {
  template = file("${path.module}/templates/mssql-unattended-install.sh.tpl")
  vars = {
    mssql_sa_password = random_password.mssql_sa_password.result
  }
}
