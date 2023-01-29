terraform {
  required_version = ">= 1.2.9"
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}
