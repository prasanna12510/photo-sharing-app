output "resource_id" {
  value = join("",aws_api_gateway_resource.main.id)
}

output "resource_path" {
  value = join("",aws_api_gateway_resource.main.path)
}
