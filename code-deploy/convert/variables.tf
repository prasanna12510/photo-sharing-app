####lambda function variables####
variable "lambda_name" {
  type        = string
  description = "lambda function name"
  default     = "convert-image"
}

variable "lambda_runtime" {
  type        = string
  description = "runtime for lambda"
  default     = "python3.7"
}

variable "lambda_function_decsription" {
  type        = string
  description = "lambda function description"
  default     = "Lambda function which converts image from one format to another"
}

variable "lambda_handler_name" {
  type        = string
  description = "lambda function handler name to convert image"
  default     = "convert_image.lambda_handler"
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

variable "commit_sha" {
  type = string
  default = "APP_TAG"
}
