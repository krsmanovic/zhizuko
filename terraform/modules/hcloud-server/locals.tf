locals {
  module_labels = merge(local.module_specific_labels, var.generic_labels)

  module_specific_labels = {
    Hostname    = var.server_name
    ServerImage = var.server_image
    ServerType  = var.server_type
  }
}
