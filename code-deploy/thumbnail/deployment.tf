thumbnail# import remote state
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

#retrieve account_id
data "aws_caller_identity" "current" {}

#####create archive for lambda function #######

resource "null_resource" "pip" {
  triggers {
    main         = "${base64sha256(file("src/main.py"))}"
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

  depends_on = ["null_resource.pip"]
}

###### upload source code to s3 bucket ######
module  "lambda_source_upload" {
  source        = "../modules/terraform/aws/s3/object"
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
  source_code_hash       = base64sha256(data.archive_file.thumbnail_image[0].output_path)
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


########api gateway method integration with lambda#######
module  "thumbnail_api_resource" {
  rest_api_id = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_id
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "thumbnail"
}

module "thumbnail_image_api_method" {
  source             = "../../modules/terraform/aws/api_gateway/rest_api_method"
  api_id             = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_id
  integration_type   = "AWS"
  http_method        = "POST"
  lambda_fuction_arn = module.thumbnail_image_lambda.arn
  api_resource_id    = "${module.thumbnail_api_resource.api_resource_id}"
  api_resource_path  = "${module.thumbnail_api_resource.api_resource_path}"
}


# deploy api
module  "thumbnail_image_api_deployment" {
  source             = "../../modules/terraform/aws/api_gateway/rest_api_deployment"
  api_id             = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_id
  stage_name         = "development"
  description        = "Deploy methods: ${module.thumbnail_image_api_method.http_method}"
}
########################outputs###########################

output "thumbnail_image_lambda_arn" {
  value = module.thumbnail_image_lambda.arn
}

output "thumbnail_image_api_method_id" {
  value = module.thumbnail_image_api_method.id
}

output "thumbnail_image_api_invoke_url" {
  value = module.thumbnail_image_api_deployment.invoke_url
}

output "apigw_execution_arn" {
  value = module.thumbnail_image_api_deployment.execution_arn
}
