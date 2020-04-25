
variable "api_id" {
  type = "string"
}

variable "api_resource_id" {
  type = "string"
}

variable "api_resource_path" {
  type = "string"
}

variable "http_method" {
  type = "string"
}

variable "authorization" {
  type = "string"
  default = "NONE"
}

variable "lambda_fuction_arn" {
  type = "string"
}

variable "integration_type" {
  type = "string"
}

variable "api_key_required" {
  type = bool
  default = false
}
