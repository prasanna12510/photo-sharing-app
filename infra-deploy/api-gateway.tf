##import remote state
data "terraform_remote_state" "photo_sharing_generic_state" {
  backend = "remote"
  config = {
    organization = "terracloud-utility"
    token        = "TF_CLOUD_TOKEN"
    workspaces = {
      name = "photo-sharing-service-generic-${terraform.workspace}"
    }
  }
}


module "photo_sharing_api" {
  source          = "../modules/terraform/aws/api_gateway/rest_api"
  api_name        = var.api_name
  api_description = var.api_description
}


output "api_id" {
  value = module.photo_sharing_api.id
}

output "api_root_resource_id" {
  value = module.photo_sharing_api.root_resource_id
}
