variable "env" {
  default = {

    play = {
      cidr           = "192.168.1.0/24"
      cidrs_public   = "192.168.1.0/28,192.168.1.16/28,192.168.1.48/28"
      cidrs_private  = "192.168.1.64/28,192.168.1.80/28,192.168.1.112/28"
    }
  }
}


variable "azs" {
  description = "Availability Zones in AWS to be use"
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "service_name" {
  description = "Tag: Service Name for all resources"
  default     = "photo-sharing"
}

variable "owner" {
  description = "Tag: Owner of the resources"
  default     = "photo-sharing"
}

variable "tag" {
  default = "APP_TAG"
}


variable "assume_role_principle" {
  type = map

  default = {
    "lambda"  = ["lambda.amazonaws.com"]
  }
}

variable "custom_policy_actions" {
  type = map
  default = {

    "lambda_s3" = ["s3:*"]

    "lambda_executor" = [
      "lambda:InvokeFunction"
    ]

    "lambda_vpc" = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
    ]

    "lambda_cloudwatch" = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    "lambda_ssm" = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]

    "lambda_sts" = [
      "sts:DecodeAuthorizationMessage"
    ]

  }
}

variable "custom_policy_resources" {
  type = map
  default = {
    "ssm"               = ["*"]
    "cloudwatch"        = ["*"]
    "lambda_vpc"        = ["*"]
    "lambda_cloudwatch" = ["*"]
    "lambda_sts"        = ["*"]
    "lambda_ssm"        = ["*"]
  }
}

variable "aws_iam_managed_policy_arns" {
  type = list
  default = [
    "",
  ]
}

variable "any_port" {
  default = "0"
}

variable "to_port" {
  default = "65535"
}

variable "any_protocol" {
  default = "-1"
}

variable "tcp_protocol" {
  default = "tcp"
}

variable "all_ips" {
  default     = ["0.0.0.0/0"]
  description = "CIDR block to accept traffic from any ip"
}
