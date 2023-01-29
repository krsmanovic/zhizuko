terraform {
  required_version = ">= 1.2.9"
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }

  backend "s3" {
    key            = "hcloud-infra.tfstate"
    bucket         = "zhizuko-tf-state-bucket"
    region         = "eu-central-1"
    dynamodb_table = "zhizuko-tf-state-lock"
  }
}

provider "hcloud" {
  token = var.hcloud_token
}
