module "lambda_sg" {
  source       = "../modules/terraform/aws/security_groups"
  vpc_id       = module.vpc.vpc_id
  name         = local.lambda_sg_name
  tags         = local.tags
  all_ips      = var.all_ips
  any_port     = var.any_port
  any_protocol = var.any_protocol
  tcp_protocol = var.any_protocol
}

# Outputs
output "lambda_security_group_id" {
  value = module.lambda_sg.sg_id
}
