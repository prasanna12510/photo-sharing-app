##############locals############
locals {

  write_object_to_s3       = [{
                                source = data.archive_file.download_image[0].output_path
                                key = "v${var.commit_sha}/download_image.zip"
                              }]

  account_id               = data.aws_caller_identity.current.account_id
  rest_api_id              = data.terraform_remote_state.photo_sharing_infra_state.outputs.api_id
  private_subnet_ids       = data.terraform_remote_state.photo_sharing_infra_state.outputs.private_subnet_ids
  lambda_security_group_id = data.terraform_remote_state.photo_sharing_infra_state.outputs.lambda_security_group_id

  apigw_source_arn         = "arn:aws:execute-api:${var.region}:${local.account_id}:${local.rest_api_id}/*/*"

  tags = {
    environment  = terraform.workspace
    version      = var.commit_sha
    name         = var.lambda_name
    ManagedBy    = "terraform"
  }
}
