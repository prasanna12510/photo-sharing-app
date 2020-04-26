# Lambda
module "lambda_role" {
  source = "../../modules/terraform/aws/iam/role_policy/role"

  role_name                   = local.lambda_role_name
  iam_assume_role_policy_data = data.aws_iam_policy_document.lambda_assume_role.json
}

module "lambda_custom_policy" {
  source = "../../modules/terraform/aws/iam/role_policy/policy/custom"

  iam_custom_policy_name      = local.lambda_policy_name
  iam_custom_role_policy_data = data.aws_iam_policy_document.lambda_runtime_policy.json
  role_name                   = [local.lambda_role_name]
}



#api gateway
module "api_gateway_role" {
  source = "../../modules/terraform/aws/iam/role_policy/role"

  role_name                   = local.api_gateway_role_name
  iam_assume_role_policy_data = data.aws_iam_policy_document.apigw_assume_role.json
}

module "api_gateway_managed_policy" {
  source = "../../modules/terraform/aws/iam/role_policy/policy/managed"

  role_name               = module.api_gateway_role.role_name
  iam_managed_policy_arns = var.aws_iam_managed_policy_arns
}


#outputs
output "lambda_role_name" {
  value = module.lambda_role.role_name
}

output "lambda_role_arn" {
  value = module.lambda_role.role_arn
}

output "api_gateway_role_name" {
  value = module.api_gateway_role.role_name
}

output "api-_gateway_role_arn" {
  value = module.api_gateway_role.role_arn
}
