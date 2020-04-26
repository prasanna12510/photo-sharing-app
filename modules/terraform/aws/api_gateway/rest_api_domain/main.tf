resource aws_api_gateway_domain_name domain {
  domain_name     = var.domain_name
  regional_certificate_arn = var.certificate_arn

  endpoint_configuration {
      types = ["REGIONAL"]
  }
}

resource aws_api_gateway_base_path_mapping base_path {
  api_id      = var.api_id
  domain_name = aws_api_gateway_domain_name.domain.domain_name
  stage_name  = var.api_stage_name
}
