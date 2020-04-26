
variable "api_id" {
  type = string
}

variable "api_resource_id" {
  type = string
}

variable "api_resource_path" {
  type = string
}

variable "http_method" {
  type = string
}

variable "authorization" {
  type = string
  default = "NONE"
}

variable "request_parameters" {
  type        = list
  default     = []
  description = "A map of request query string parameters and headers that should be passed to the integration. For example: request_parameters = {\"method.request.header.X-Some-Header\" = true \"method.request.querystring.some-query-param\" = true} would define that the header X-Some-Header and the query string some-query-param must be provided in the request."
}

variable "lambda_fuction_arn" {
  type = string
  default = ""
}

variable "bucket_name" {
  type = string
  default = ""
}


variable "integration_type" {
  type = string
}

variable "integration_request_parameters" {
  type        = list
  default     = []
  description = "A map of request query string parameters and headers that should be passed to the backend responder. For example: request_parameters = { \"integration.request.header.X-Some-Other-Header\" = \"method.request.header.X-Some-Header\" }."
}

variable "api_key_required" {
  type = bool
  default = false
}

variable "lambda_proxy" {
  type = bool
  default = true
}
