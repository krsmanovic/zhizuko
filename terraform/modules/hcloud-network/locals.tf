locals {
  module_labels = merge(local.module_specific_labels, var.generic_labels)

  module_specific_labels = {
    Description = "Network"
  }
}
