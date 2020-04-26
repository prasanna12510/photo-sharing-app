output domain_name {
  description = "Custom domain name."
  value       = "${aws_api_gateway_domain_name.domain.domain_name}"
}

output regional_domain_name {
  value = "${aws_api_gateway_domain_name.domain.regional_domain_name}"
}

output regional_zone_id {
  value = "${aws_api_gateway_domain_name.domain.regional_zone_id}"
}
