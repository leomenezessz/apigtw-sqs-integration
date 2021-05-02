
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}


resource "aws_cloudwatch_log_group" "basic-api-cloudwatch-group" {
  provider = aws.us-east-1

  name              = "/aws/apigateway/${aws_api_gateway_rest_api.basic-api.name}"
  retention_in_days = 1
}


data "aws_iam_policy_document" "basic-apigateway-logging-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:log-group:/aws/apigateway/*"]

    principals {
      identifiers = ["apigateway.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "apigateway-logging-policy" {
  provider = aws.us-east-1

  policy_document = data.aws_iam_policy_document.basic-apigateway-logging-policy.json
  policy_name     = "basic-apigateway-query-logging-policy"
}