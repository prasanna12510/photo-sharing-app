####lambda function variables####
variable "request_parameters" {
  type = map
  default = {
      "method.request.path.id"                    = true
      "method.request.path.filename"              = true
      "method.request.header.Content-Type"        = false
      "method.request.header.Content-Disposition" = false

    }
}


variable "integration_request_parameters" {
  type = map
  default = {
      "integration.request.path.id"       = "method.request.path.id"
      "integration.request.path.filename" = "method.request.path.filename"
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
