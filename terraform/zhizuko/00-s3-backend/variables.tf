variable "application_name" {
  type        = string
  description = "Resource prefixed added to all resources"
}

variable "backend_specific_tags" {
  type        = map(any)
  description = "A map of resource tags to be applied to S3 bucket and DynamoDB table"
  default     = {}
}
