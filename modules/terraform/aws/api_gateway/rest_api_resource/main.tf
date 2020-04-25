resource "aws_api_gateway_resource" "api-resource" {
  rest_api_id = var.api_id
  parent_id   = var.api_root_resource_id
  path_part   = var.resource_path
}
