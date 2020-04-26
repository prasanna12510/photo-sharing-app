output domain_name {
  description = "Custom domain name."
  value       = "${aws_api_gateway_domain_name.domain.domain_name}"
}

output cloudfront_domain_name {
  value = "${aws_api_gateway_domain_name.domain.cloudfront_domain_name}"
}

output cloudfront_zone_id {
  value = "${aws_api_gateway_domain_name.domain.cloudfront_zone_id}"
}
