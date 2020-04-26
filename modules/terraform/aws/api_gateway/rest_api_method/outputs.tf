output "http_method_id" {
  value = "${aws_api_gateway_method.api-method.id}"
}

output "http_method" {
  value = "${aws_api_gateway_method.api-method.http_method}"
}

output "ok_response" {
  value = "${aws_api_gateway_method_response.ok.status_code}"
}

output "deployment_id" {
  value = "${aws_api_gateway_deployment.api_deployment.id}"
}

output "invoke_url" {
  value = "${aws_api_gateway_deployment.api_deployment.invoke_url}"
}

output "execution_arn" {
  value = "${aws_api_gateway_deployment.api_deployment.execution_arn}"
}
