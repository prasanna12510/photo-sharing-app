# We can deploy the API now! (i.e. make it publicly available)
resource "aws_api_gateway_deployment" "main" {
  rest_api_id = var.api_id
  stage_name  = var.stage_name
  description = var.description
}
