output "apigateway_resource_one" {
  value = "${aws_api_gateway_deployment.deployment_apigateway.invoke_url}${var.stage_name}/${aws_api_gateway_resource.resource_one.path_part}"
}

output "apigateway_resource_two" {
  value = "${aws_api_gateway_deployment.deployment_apigateway.invoke_url}${var.stage_name}/${aws_api_gateway_resource.resource_two.path_part}"
}