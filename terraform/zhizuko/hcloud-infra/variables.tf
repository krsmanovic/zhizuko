variable "application_name" {
  type        = string
  description = "Resource prefixed added to all resources"
}

variable "hcloud_token" {
  type      = string
  default   = ""
  sensitive = true

  validation {
    condition     = length(var.hcloud_token) > 0
    error_message = "Please set Hetzner Cloud API token, e.g., by exporting TF_VAR_hcloud_token environment variable."
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

variable "server_name" {
  type        = string
  description = "Server hostname"
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

variable "server_base_image" {
  type        = string
  description = "Base OS image to use for server deployment"
  default     = "ubuntu-22.04"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key IDs or names which should be injected into the server at creation time"
  default     = "default"
}

variable "app_specific_labels" {
  type        = map(any)
  description = "A map of resource tags to be applied to all module resources"
  default     = {}
}

variable "umbraco_friendly_name" {
  type        = string
  description = "Umbraco user name written in friendly format, e.g., \"A.N. Other\""
  default     = "A.N. Other"
}

variable "umbraco_email" {
  type        = string
  description = "Umbraco user email address"
  default     = "AN@Other.com"
}

