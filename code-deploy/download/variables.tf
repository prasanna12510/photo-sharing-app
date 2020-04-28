####lambda function variables####
variable "request_parameters" {
  type = map
  default = {
      "method.request.path.image_id"              = true
      "method.request.header.Content-Type"        = false
      "method.request.header.Content-Disposition" = false

    }
}


variable "integration_request_parameters" {
  type = map
  default = {
      "integration.request.path.image_id"       = "method.request.path.image_id"
      "integration.request.header.Content-Type" = "method.request.header.Content-Type"
      "integration.request.header.Content-Disposition" = "method.request.header.Content-Disposition"
    }
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "commit_sha" {
  type = string
  default = "APP_TAG"
}
