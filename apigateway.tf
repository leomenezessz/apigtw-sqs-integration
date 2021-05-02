resource "aws_api_gateway_rest_api" "apigateway" {
  name = var.apigateway_name
}

resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.role_apigateway.arn
  depends_on          = [aws_iam_role_policy_attachment.apigateway_sqs_policy_attachment, aws_cloudwatch_log_group.apigateway_log_group]
}

# RESOURCE ONE CONFIGURATION

resource "aws_api_gateway_resource" "resource_one" {
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "one"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_method" "resource_one_method" {
  authorization        = "NONE"
  http_method          = "POST"
  resource_id          = aws_api_gateway_resource.resource_one.id
  rest_api_id          = aws_api_gateway_rest_api.apigateway.id
  request_validator_id = aws_api_gateway_request_validator.request_validator_resource_one.id
  request_models = {
    "application/json" = aws_api_gateway_model.resource_one_model.name
  }
}

resource "aws_api_gateway_model" "resource_one_model" {
  rest_api_id  = aws_api_gateway_rest_api.apigateway.id
  name         = "ModelOne"
  content_type = "application/json"
  schema       = <<EOF
  {
      "$schema": "http://json-schema.org/draft-07/schema",
      "type": "object",
      "required": [
          "id",
          "message",
          "value"
      ],
      "properties": {
          "id": {
              "type": "integer"
          },
          "message": {
              "type": "string"
          },
          "value": {
              "type": "number"
          }
      }
  }
EOF
}

resource "aws_api_gateway_request_validator" "request_validator_resource_one" {
  name                  = "RequestValidatorResourceOne"
  rest_api_id           = aws_api_gateway_rest_api.apigateway.id
  validate_request_body = true
}

resource "aws_api_gateway_integration" "resource_one_integration" {
  http_method             = "POST"
  credentials             = aws_iam_role.role_apigateway.arn
  resource_id             = aws_api_gateway_resource.resource_one.id
  rest_api_id             = aws_api_gateway_rest_api.apigateway.id
  integration_http_method = "POST"
  passthrough_behavior    = "NEVER"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:sqs:path/${aws_sqs_queue.queue.name}"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }

  depends_on = [
    aws_api_gateway_resource.resource_one,
    aws_api_gateway_method.resource_one_method
  ]
}

resource "aws_api_gateway_integration_response" "resource_one_integration_response" {
  http_method = aws_api_gateway_method.resource_one_method.http_method
  resource_id = aws_api_gateway_resource.resource_one.id
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  status_code = aws_api_gateway_method_response.resource_one_integration_method_response.status_code

  response_templates = {
    "application/json" = "{\"message\": \"Resource one sending message!\"}"
  }

  depends_on = [aws_api_gateway_integration.resource_one_integration]
}

resource "aws_api_gateway_method_response" "resource_one_integration_method_response" {
  http_method = aws_api_gateway_method.resource_one_method.http_method
  resource_id = aws_api_gateway_resource.resource_one.id
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }
}

# RESOURCE TWO CONFIGURATION

resource "aws_api_gateway_resource" "resource_two" {
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "two"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_method" "resource_two_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.resource_two.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
}

resource "aws_api_gateway_integration" "resource_two_integration" {
  http_method             = "POST"
  credentials             = aws_iam_role.role_apigateway.arn
  resource_id             = aws_api_gateway_resource.resource_two.id
  rest_api_id             = aws_api_gateway_rest_api.apigateway.id
  integration_http_method = "POST"
  passthrough_behavior    = "NEVER"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:sqs:path/${aws_sqs_queue.queue.name}"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }

  depends_on = [aws_api_gateway_method.resource_two_method, aws_api_gateway_resource.resource_two]
}

resource "aws_api_gateway_integration_response" "resource_two_integration_response" {
  http_method = aws_api_gateway_method.resource_two_method.http_method
  resource_id = aws_api_gateway_resource.resource_two.id
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  status_code = aws_api_gateway_method_response.resource_two_integration_method_response.status_code

  response_templates = {
    "application/json" = "{\"message\": \"Resource two sending message!\"}"
  }

  depends_on = [aws_api_gateway_integration.resource_two_integration]
}

resource "aws_api_gateway_method_response" "resource_two_integration_method_response" {
  http_method = aws_api_gateway_method.resource_two_method.http_method
  resource_id = aws_api_gateway_resource.resource_two.id
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }
}

# METHOD SETTINGS

resource "aws_api_gateway_method_settings" "method_settings_apigateway" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  stage_name  = aws_api_gateway_stage.apigateway_stage.stage_name
  method_path = "*/*"

  settings {
    logging_level = "INFO"
  }

  depends_on = [aws_api_gateway_account.api_gateway_account]
}

# STAGE

resource "aws_api_gateway_stage" "apigateway_stage" {
  deployment_id = aws_api_gateway_deployment.deployment_apigateway.id
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  stage_name    = var.stage_name
  depends_on    = [aws_iam_policy.policy_apigateway_sqs]
}

# DEPLOYMENT SECTION

resource "aws_api_gateway_deployment" "deployment_apigateway" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id

  depends_on = [
    aws_api_gateway_integration.resource_one_integration,
    aws_api_gateway_integration.resource_two_integration,
    aws_api_gateway_account.api_gateway_account
  ]

  lifecycle {
    create_before_destroy = true
  }
}

