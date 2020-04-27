variable "api_id" {
  type = string
}

variable "api_root_resource_id" {
  type = string
}

variable "path_parts" {
  type        = list
  default     = []
  description = "The last path segment of this API resource."
}
