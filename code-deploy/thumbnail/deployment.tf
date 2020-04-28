## import remote state
data "terraform_remote_state" "photo_sharing_infra_state" {
  backend = "remote"
  config = {
    hostname     = "app.terraform.io"
    organization = "terracloud-utility"
    token        = "TF_CLOUD_TOKEN"
    workspaces = {
      name = "photo-sharing-service-infra-${terraform.workspace}"
    }
  }
}

#retrieve account_id
data "aws_caller_identity" "current" {}

#####create archive for lambda function #######

resource "null_resource" "pip" {
  triggers = {
    main         = "${base64sha256(file("src/thumbnail_image.py"))}"
    requirements = "${base64sha256(file("src/requirements.txt"))}"
  }

  provisioner "local-exec" {
    command = "./pip.sh ${path.module}/src"
  }
}

data "archive_file" "thumbnail_image" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/thumbnail_image.zip"

  depends_on = [null_resource.pip]
}

###### upload source code to s3 bucket ######
module  "lambda_source_upload" {
  source        = "../../modules/terraform/aws/s3/object"
  bucket_name   = data.terraform_remote_state.photo_sharing_infra_state.outputs.lambda_source_code_s3_bucket_name
  write_objects = local.write_object_to_s3
}

################lambda for upload images#########
module "thumbnail_image_lambda" {
  source                 = "../../modules/terraform/aws/lambda/function"
  vpc_subnet_ids         = local.private_subnet_ids
  vpc_security_group_ids = [local.lambda_security_group_id]
  iam_role_arn           = data.terraform_remote_state.photo_sharing_infra_state.outputs.lambda_role_arn
  bucket_name            = data.terraform_remote_state.photo_sharing_infra_state.outputs.lambda_source_code_s3_bucket_name
  bucket_key             = module.lambda_source_upload.id
  runtime                = var.lambda_runtime
  timeout                = var.lambda_timeout
  func_name              = var.lambda_name
  func_handler           = var.lambda_handler_name
  source_code_hash       = base64sha256(data.archive_file.thumbnail_image.output_path)
  description            = var.lambda_function_decsription
  tags                   = local.tags
  environment_variables  = {
    ENVIRONMENT    = terraform.workspace
    LOG_EVENTS     = var.lambda_log_events
    BUCKET_NAME    = data.terraform_remote_state.photo_sharing_infra_state.outputs.image_storage_s3_bucket_name
  }
}

#########################api gateway integration with lambda##################################
module "thumbnail_image_lambda_permission" {
  source        = "../../modules/terraform/aws/lambda/permission"
  create        = true
  statement_id  = var.lambda_permission.statement_id
  action        = var.lambda_permission.action
  function_name = module.thumbnail_image_lambda.func_name
  principal     = var.lambda_permission.principal
  source_arn    = local.apigw_source_arn
}

#######api gateway method integration with lambda#######
#/thumbnail/{id}?size=100x100
module  "thumbnail_api_resource" {
  source                 = "../../modules/terraform/aws/api_gateway/rest_api_resource"
  api_id                 = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_id
  api_root_resource_id   = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_root_resource_id
  path_parts             = ["thumbnail"]
}

module  "thumbnail_api_resource_image_id" {
  source                 = "../../modules/terraform/aws/api_gateway/rest_api_resource"
  api_id                 = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_id
  api_root_resource_id   = module.thumbnail_api_resource.resource_id
  path_parts              = ["{image_id}"]
}


module "thumbnail_image_api_method" {
  source             = "../../modules/terraform/aws/api_gateway/rest_api_method"
  lambda_proxy       = true
  api_id             = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_id
  integration_type   = "AWS_PROXY"
  http_method        = "POST"
  request_validator_name = "thumbnail_image_request_validator"
  lambda_fuction_arn = module.thumbnail_image_lambda.arn
  api_resource_id    = module.thumbnail_api_resource_image_id.resource_id
  api_resource_path  = module.thumbnail_api_resource_image_id.resource_path
  stage_name         = "dev"
  description        = "Deploy methods: ${module.thumbnail_image_api_method.http_method}"
  credentials        = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_gateway_role_arn
  request_parameters = var.request_parameters
  integration_request_parameters  = var.integration_request_parameters
}

########################outputs###########################

output "thumbnail_image_lambda_arn" {
  value = module.thumbnail_image_lambda.arn
}

output "thumbnail_image_api_method_id" {
  value = module.thumbnail_image_api_method.http_method_id
}

output "thumbnail_image_api_invoke_url" {
  value = module.thumbnail_image_api_method.invoke_url
}

output "apigw_execution_arn" {
  value = module.thumbnail_image_api_method.execution_arn
}
