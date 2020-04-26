resource "aws_api_gateway_rest_api" "api" {
  name               = var.api_name
  description        = var.api_description
  binary_media_types  = var.binary_media_types 
}
