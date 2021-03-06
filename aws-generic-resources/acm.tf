###create acm certificate in generic level
module "acm" {
  source           = "../modules/terraform/aws/acm"
  domain_name      = var.certificate_domain_name
  hosted_zone_name = var.hosted_zone_name
  certificate_name = "wildcard.${var.hosted_zone_name}"
  environment      = "play"
  description      = "Wildcard certificate for mywebapplication.ml"
  product_domain   = "photo-sharing-api"
}

output "acm_cert_arn" {
  value = module.acm.acm_certificate_arn
}
