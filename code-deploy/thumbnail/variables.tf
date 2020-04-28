
####apigw integration variables####
variable "request_parameters" {
  type = map
  default = {
      "method.request.path.image_id"    = true
      "method.request.querystring.size" = true
    }
}


variable "integration_request_parameters" {
  type = map
  default = {
      "integration.request.path.image_id"    = "method.request.path.image_id"
      "integration.request.querystring.size" = "method.request.querystring.size"
    }
}

####lambda function variables####
variable "lambda_name" {
  type        = string
  description = "lambda function name"
  default     = "thumbnail-image"
}

variable "lambda_runtime" {
  type        = string
  description = "runtime for lambda"
  default     = "python3.7"
}

variable "lambda_function_decsription" {
  type        = string
  description = "lambda function description"
  default     = "Lambda function which creates thumbnail for given input image"
}

variable "lambda_handler_name" {
  type        = string
  description = "lambda function handler name to thumbnail image"
  default     = "thumbnail_image.lambda_handler"
}

variable "lambda_timeout" {
  type        = number
  default     = 60
}

variable "lambda_log_events" {
  type        = bool
  description = "log events for lambda function"
  default     = true
}

variable "lambda_permission" {
  type = map

  default = {
    "statement_id" = "AllowExecutionFromApiGateway"
    "action"       = "lambda:InvokeFunction"
    "principal"    = "apigateway.amazonaws.com"
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
