variable "dashboard_name" {
  description = "The name you want to use for this CloudWatch dashboard"
  type        = string
}

variable "dashboard_body" {
  description = "json body of dashboard"
}

variable "create_dashboard" {
  type = bool
  description = "create dashboard "
  default = false
}
