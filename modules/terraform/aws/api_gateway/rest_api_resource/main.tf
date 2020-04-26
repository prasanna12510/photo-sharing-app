resource "aws_api_gateway_resource" "main" {
  count = length(var.path_parts) > 0 ? length(var.path_parts) : 0
  rest_api_id = var.api_id
  parent_id   = var.api_root_resource_id
  path_part   = element(var.path_parts, count.index)
}
