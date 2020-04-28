##############locals############
locals {

  tags = {
    environment  = terraform.workspace
    version      = var.commit_sha
    ManagedBy    = "terraform"
  }
}
