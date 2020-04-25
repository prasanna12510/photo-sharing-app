output "resource_id" {
  value = "${aws_api_gateway_resource.api-resource.id}"
}

output "resource_path" {
  value = "${aws_api_gateway_resource.api-resource.path}"
}
