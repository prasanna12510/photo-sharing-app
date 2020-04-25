#route53 variables
variable "hosted_zone_name" {
  default = "mywebapplication.ml"
}

variable "certificate_domain_name" {
  default = "*.mywebapplication.ml"
}
#s3 bucket variables
variable "acl"{
  description = "Access Control List"
  default     = "private"
}

variable "versioning"{
  description = "Versioning"
  default     = true
}

variable "force-destroy"{
  description = "Force Destroy Option"
  default     = true
}


variable "commit_sha" {
  type = string
  default = "APP_TAG"
}
