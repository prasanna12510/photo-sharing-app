##############locals############
locals {

  lambda_role_name          = "${var.service_name}-lambda-role-${terraform.workspace}"
  lambda_policy_name        = "${var.service_name}-lambda-policy-${terraform.workspace}"
  image_storage_bucket_name = "${var.service_name}-${terraform.workspace}"
  lambda_sg_name            = "${var.service_name}-lambda-security-group-${terraform.workspace}"

  tags = {
    environment  = terraform.workspace
    version      = var.commit_sha
    name         = local.s3_bucket_name
    ManagedBy    = "terraform"
  }
}
