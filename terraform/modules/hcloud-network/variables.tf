variable "hcloud_location" {
  type        = string
  description = "The location name to create the server in"
  default     = "nbg1"

  validation {
    condition     = contains(["nbg1", "fsn1", "hel1", "ash"], var.hcloud_location)
    error_message = "Valid values for variable \"hcloud_location\" are: nbg1, fsn1, hel1, ash."
  }
}

variable "private_ip_range" {
  type        = string
  description = "IP Range of the whole Network which must span all included subnets and route destinations. Must be one of the private ipv4 ranges of RFC1918."
  default     = "10.0.0.0/16"
}

variable "private_network_name" {
  type        = string
  description = "Name of the Network to create (must be unique per project)"
  default     = "default"
}

variable "private_network_zone" {
  type        = string
  description = "Name of network zone"
  default     = "eu-central"

  validation {
    condition     = contains(["eu-central", "us-east", "us-west"], var.private_network_zone)
    error_message = "Valid values for variable \"private_network_zone\" are: eu-central, us-east, us-west."
  }
}

variable "enable_floating_ip" {
  type        = bool
  description = "Enable or disable floating IP"
  default     = false
}

variable "floating_ip_name" {
  type        = string
  description = "Name of the Floating IP"
  default     = "default"
}

variable "generic_labels" {
  type        = map(any)
  description = "A map of resource tags to be applied to all module resources"
  default     = {}
}
