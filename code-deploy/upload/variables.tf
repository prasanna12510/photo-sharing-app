####lambda function variables####

variable "request_parameters" {
  type = map
  default ={
      "method.request.header.Content-Type" = false
    }

}


variable "integration_request_parameters" {
  type = map
  default ={
    "integration.request.header.Accept"       = "'image/webp,image/*,*/*'"
    "integration.request.header.Content-Type" = "method.request.header.Content-Type"

    }

}

variable "lambda_name" {
  type        = string
  description = "lambda function name"
  default     = "upload-image"
}

variable "lambda_runtime" {
  type        = string
  description = "runtime for lambda"
  default     = "python3.7"
}

variable "lambda_function_decsription" {
  type        = string
  description = "lambda function description"
  default     = "Lambda function which uploads image from one format to another"
}

variable "lambda_handler_name" {
  type        = string
  description = "lambda function handler name to upload image"
  default     = "upload_image.lambda_handler"
}

variable "lambda_timeout" {
  type        = number
  default     = 30
}

variable "lambda_log_events" {
  type        = bool
  description = "log events for lambda function"
  default     = true
}

#####lambda function variables#####
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
