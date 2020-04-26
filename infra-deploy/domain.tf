data "aws_route53_zone" "dns_zone" {
  name         = "${var.hosted_zone_name}." # Notice the dot!!!
  private_zone = false
}

module "photo_sharing_api_gateway_domain" {
  source          = "../modules/terraform/aws/api_gateway/rest_api_domain"
  api_id          = module.photo_sharing_api.id
  api_stage_name  = "dev"
  domain_name     = "progimage.mywebapplication.ml"
  certificate_arn = data.terraform_remote_state.photo_sharing_generic_state.outputs.acm_cert_arn
}

module "photo_sharing_api_route53_record" {
  source          = "../modules/terraform/aws/route53/recordsets"
  zone_id         = data.aws_route53_zone.dns_zone.zone_id
  aliases         = [module.photo_sharing_api_gateway_domain.domain_name]
  target_zone_id  = module.photo_sharing_api_gateway_domain.cloudfront_zone_id
  target_dns_name = module.photo_sharing_api_gateway_domain.cloudfront_domain_name
  is_A_record     = true
}


output "apigw_domain_name" {
  value = module.photo_sharing_api_gateway_domain.domain_name
}
