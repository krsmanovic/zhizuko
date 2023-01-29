variable "server_name" {
  type        = string
  description = "Name of the server"
  default     = "hcloud-host"
}

variable "server_type" {
  type        = string
  description = "Type of standard (non-dedicated) Hetzner VPS offering"
  default     = "cx11"

  validation {
    condition     = contains(["cx11", "cpx11", "cx21", "cpx21", "cx31", "cpx31", "cx41", "cpx41", "cx51", "cpx51"], var.server_type)
    error_message = "Valid values for variable \"server_type are\": cx11, cpx11, cx21, cpx21, cx31, cpx31, cx41, cpx41, cx51, cpx51."
  }
}

variable "hcloud_location" {
  type        = string
  description = "The location name to create the server in"
  default     = "nbg1"

  validation {
    condition     = contains(["nbg1", "fsn1", "hel1", "ash"], var.hcloud_location)
    error_message = "Valid values for variable \"hcloud_location\" are: nbg1, fsn1, hel1, ash."
  }
}

variable "hcloud_datacenter" {
  type        = string
  description = "Datacenter to create the server in"
  default     = "nbg1-dc3"
}


variable "server_image" {
  type        = string
  description = "Name or ID of the image the server is created from"
  default     = "ubuntu-22.04"
}

variable "ssh_public_key_name" {
  type        = string
  description = "SSH key IDs or names which should be injected into the server at creation time"
  default     = "default"
}

variable "user_data" {
  type        = string
  description = "Cloud-Init user data to use during server creation"
  default     = ""
}

variable "enable_backups" {
  type        = bool
  description = "Enable or disable backups"
  default     = false
}

variable "generic_labels" {
  type        = map(any)
  description = "A map of resource tags to be applied to all module resources"
  default     = {}
}

variable "network_id" {
  type        = string
  description = "ID of the network which should be added to the server"
}

variable "enable_floating_ip" {
  type        = bool
  description = "Enable or disable floating IP"
  default     = false
}

variable "floating_ip_id" {
  type        = string
  description = "Floating IP ID"
  default     = ""
}

variable "enable_public_ipv4" {
  type        = bool
  description = "Enable or disable public IPv4 address"
  default     = true
}

variable "enable_public_ipv6" {
  type        = bool
  description = "Enable or disable public IPv6 address"
  default     = false
}