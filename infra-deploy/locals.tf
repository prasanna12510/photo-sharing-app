##############locals############
locals {

  name                = "${var.service_name}-${terraform.workspace}"
  cidr                = var.env[terraform.workspace].cidr
  private_subnets     = "${split(",", var.env[terraform.workspace].cidrs_private)}"
  public_subnets      = "${split(",", var.env[terraform.workspace].cidrs_public)}"
  max_subnet_length   = max(length(local.private_subnets), )

  lambda_role_name                          = "${var.service_name}-lambda-role-${terraform.workspace}"
  lambda_policy_name                        = "${var.service_name}-lambda-policy-${terraform.workspace}"
  image_storage_bucket_name                 = "${var.service_name}-${terraform.workspace}"
  lambda_source_code_bucket_name            = "${var.service_name}-source-${terraform.workspace}"
  lambda_sg_name                            = "${var.service_name}-lambda-security-group-${terraform.workspace}"
  
  tags = {
    environment  = terraform.workspace
    version      = var.commit_sha
    name         = local.s3_bucket_name
    ManagedBy    = "terraform"
  }
}
