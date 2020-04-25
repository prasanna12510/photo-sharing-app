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

output "image_storage_s3_bucket_name" {
  value = module.image_storage_s3_bucket.bucket_id
}
