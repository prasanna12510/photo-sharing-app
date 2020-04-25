output domain_name {
  description = "Custom domain name."
  value       = "${aws_api_gateway_domain_name.domain.domain_name}"
}
