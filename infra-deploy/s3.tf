#####s3 bucket for lambda source code#######
module "lambda_source_code_s3_bucket" {
  source = "../modules/terraform/aws/s3/bucket"
  name          = local.lambda_source_code_bucket_name
  acl           = var.acl
  force_destroy = var.force-destroy
  tags          = local.tags
  versioning = {
    enabled = var.versioning
  }
  s3_tags = {
    Name = local.lambda_source_code_bucket_name
  }
}

#####s3 bucket for storing images #######
module "image_storage_s3_bucket" {
  source = "../modules/terraform/aws/s3/bucket"
  name          = local.image_storage_bucket_name
  acl           = var.acl
  force_destroy = var.force-destroy
  tags          = local.tags
  versioning = {
    enabled = var.versioning
  }
  s3_tags = {
    Name = local.image_storage_bucket_name
  }
}

output "lambda_source_code_s3_bucket_name" {
  value = module.lambda_source_code_s3_bucket.bucket_id
}

output "image_storage_s3_bucket_name" {
  value = module.image_storage_s3_bucket.bucket_id
}
