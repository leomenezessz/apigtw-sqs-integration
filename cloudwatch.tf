
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

resource "aws_cloudwatch_log_group" "hello_lambda_log_group" {
  provider          = aws.us-east-1
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "apigateway_log_group" {
  provider = aws.us-east-1
  name     = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.apigateway.id}/${var.stage_name}"

  retention_in_days = 1
}