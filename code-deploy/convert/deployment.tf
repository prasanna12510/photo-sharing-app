# Import Remote State
data "terraform_remote_state" "photo_sharing_infra_state" {
  backend = "remote"
  config = {
    hostname     = "app.terraform.io"
    organization = "terracloud-utility"
    token        = "TF_CLOUD_TOKEN"
    workspaces = {
      name = "photo-sharing-infra-${terraform.workspace}"
    }
  }
}

data "aws_caller_identity" "current" {}

#####s3 bucket for lambda source code#######
module "convert_image_s3_bucket" {
  source = "../modules/terraform/aws/s3/bucket"
  name          = local.s3_bucket_name
  acl           = var.acl
  force_destroy = var.force-destroy
  tags          = local.tags
  versioning = {
    enabled = var.versioning
  }
  s3_tags = {
    Name = local.s3_bucket_name
  }
}

#####create archive for lambda function #######
data "null_data_source" "lambda_file" {
  inputs = {
    filename = "${path.module}/src/convert_image.py"
  }
}

data "null_data_source" "lambda_archive" {
  inputs = {
    filename = "${path.module}/src/convert_image.zip"
  }
}

data "archive_file" "convert_image" {
  count = 1

  type        = "zip"
  source_file = data.null_data_source.lambda_file.outputs.filename
  output_path = data.null_data_source.lambda_archive.outputs.filename
}


##upload source code to s3 bucket
module  "lambda_source_upload" {
  source = "../modules/terraform/aws/s3/object"
  bucket_name = module.convert_lambda_s3_bucket.bucket_id
  write_objects = local.write_object_to_s3
}

###########################lambda for convert images######################
module "convert_image_lambda" {
  source = "../../modules/terraform/aws/lambda/function"
  vpc_subnet_ids         = local.private_subnet_ids
  vpc_security_group_ids = [local.lambda_security_group_id]
  iam_role_arn           = data.terraform_remote_state.photo_sharing_infra_state.outputs.lambda_role_arn
  bucket_name            = module.convert_lambda_s3_bucket.bucket_id
  bucket_key             = module.lambda_source_upload.id
  runtime                = var.lambda_runtime
  timeout                = var.lambda_timeout
  func_name              = var.lambda_name
  func_handler           = var.lambda_handler_name
  source_code_hash       = base64sha256(data.archive_file.convert_image[0].output_path)
  description            = var.lambda_function_decsription
  tags                   = local.tags
  environment_variables = {
    ENVIRONMENT       = terraform.workspace
    LOG_EVENTS        = var.lambda_log_events
  }
}

########################outputs###########################
output "convert_image_s3_bucket_name" {
  value = module.convert_image_s3_bucket.bucket_id
}

output "convert_image_lambda_arn" {
  value = module.convert_image_lambda.arn
}
