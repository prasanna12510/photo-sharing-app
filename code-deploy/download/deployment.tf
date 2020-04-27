# import remote state
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



########api gateway method integration with lambda#######
#/download/{id}/{filename}
module  "download_api_resource" {
  source                 = "../../modules/terraform/aws/api_gateway/rest_api_resource"
  api_id                 = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_id
  api_root_resource_id   = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_root_resource_id
  path_parts             = ["download"]
}

module  "download_api_resource_download_id" {
  source                 = "../../modules/terraform/aws/api_gateway/rest_api_resource"
  api_id                 = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_id
  api_root_resource_id   = module.download_api_resource.resource_id
  path_parts              = ["{id}"]
}

module  "download_api_resource_download_filename" {
  source                 = "../../modules/terraform/aws/api_gateway/rest_api_resource"
  api_id                 = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_id
  api_root_resource_id   = module.download_api_resource_download_id.resource_id
  path_parts             = ["{filename}"]
}

module "download_image_api_method" {
  source                          = "../../modules/terraform/aws/api_gateway/rest_api_method"
  lambda_proxy                    = false
  api_id                          = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_id
  integration_type                = "AWS"
  http_method                     = "GET"
  bucket_name                     = data.terraform_remote_state.photo_sharing_infra_state.outputs.image_storage_s3_bucket_name
  api_resource_id                 = module.download_api_resource.resource_id
  api_resource_path               = module.download_api_resource.resource_path
  request_parameters              = var.request_parameters
  integration_request_parameters  = var.integration_request_parameters
  stage_name                      = "dev"
  description                     = "Deploy methods: ${module.download_image_api_method.http_method}"
}

########################outputs###########################


output "download_image_api_method_id" {
  value = module.download_image_api_method.http_method_id
}

output "download_image_api_invoke_url" {
  value = module.download_image_api_method.invoke_url
}

output "apigw_execution_arn" {
  value = module.download_image_api_method.execution_arn
}
