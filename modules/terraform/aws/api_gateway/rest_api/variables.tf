
variable "api_name" {
  type = string
}

variable "binary_media_types" {
  type = list
  default = ["*/*"]
}

variable "api_description" {
  type = string
}
