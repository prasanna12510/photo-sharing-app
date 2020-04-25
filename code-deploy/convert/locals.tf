##############locals############
locals {

  s3_bucket_name         = "convert-image-source-${terraform.workspace}"
  write_object_to_s3     = [{
                          source = data.archive_file.convert_image[0].output_path
                          key = "convert_image-${var.commit_sha}.zip"
                          }]
  tags = {
    environment  = terraform.workspace
    version      = var.commit_sha
    name         = local.s3_bucket_name
    ManagedBy    = "terraform"
  }
}
