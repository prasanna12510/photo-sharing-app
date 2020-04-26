output "dns_record_name" {
  value = var.is_A_record ? concat(aws_route53_record.a_type_record.*.name, [""])[0] : concat(aws_route53_record.not_a_type_record.*.name, [""])[0]
}

output "cloudfront_domain_name" {
  value = var.is_A_record ? concat(aws_route53_record.a_type_record.*.cloudfront_domain_name, [""])[0] : ""
}

output "cloudfront_zone_id" {
  value = var.is_A_record ? concat(aws_route53_record.a_type_record.*.cloudfront_zone_id, [""])[0] : ""
}


output "dns_record_value" {
  value = var.is_A_record ? aws_route53_record.a_type_record.*.records : aws_route53_record.not_a_type_record.*.records
}
