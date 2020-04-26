
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.assume_role_principle.lambda
    }
  }
}



data "aws_iam_policy_document" "apigw_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.assume_role_principle.apigw
    }
  }
}


data "aws_iam_policy_document" "s3_policy" {

  statement {
    sid       = "AllowAccessToS3Bucket"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${local.image_storage_bucket_name}/*"]
    actions   = var.custom_policy_actions.s3

    principals {
      type        = "Service"
      identifiers = var.assume_role_principle.apigw
    }
  }
}

data "aws_iam_policy_document" "lambda_runtime_policy" {

  // allow VPC access
  statement {
    sid       = "AllowConnectionToVPC"
    effect    = "Allow"
    resources = var.custom_policy_resources.lambda_vpc
    actions   = var.custom_policy_actions.lambda_vpc
  }

  // allow logging to cloudwatch
  statement {
    sid       = "AllowLogToCloudwatch"
    effect    = "Allow"
    resources = var.custom_policy_resources.lambda_cloudwatch
    actions   = var.custom_policy_actions.lambda_cloudwatch
  }

  // allow decode error
  statement {
    sid       = "AllowDecodeAuthorizationError"
    effect    = "Allow"
    resources = var.custom_policy_resources.lambda_sts
    actions   = var.custom_policy_actions.lambda_sts
  }

  // allow read parameter store
  statement {
    sid       = "AllowReadParameterStore"
    effect    = "Allow"
    resources = var.custom_policy_resources.lambda_ssm
    actions   = var.custom_policy_actions.lambda_ssm
  }

  statement {
    sid       = "AllowAccessToS3Bucket"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${local.lambda_source_code_bucket_name}/*","arn:aws:s3:::${local.image_storage_bucket_name}/*"]
    actions   = var.custom_policy_actions.lambda_s3
  }
}
