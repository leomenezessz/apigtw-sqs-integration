resource "aws_api_gateway_rest_api" "basic-api" {
  name = "BasicApi"
}

# RESOURCE ONE CONFIGURATION

resource "aws_api_gateway_resource" "resource-one" {
  parent_id   = aws_api_gateway_rest_api.basic-api.root_resource_id
  path_part   = "one"
  rest_api_id = aws_api_gateway_rest_api.basic-api.id
}

resource "aws_api_gateway_method" "resource-one-method" {
  authorization        = "NONE"
  http_method          = "POST"
  resource_id          = aws_api_gateway_resource.resource-one.id
  rest_api_id          = aws_api_gateway_rest_api.basic-api.id
  request_validator_id = aws_api_gateway_request_validator.request-validator-resource-one.id
  request_models = {
    "application/json" = aws_api_gateway_model.resource-one-model.name
  }
}

resource "aws_api_gateway_model" "resource-one-model" {
  rest_api_id  = aws_api_gateway_rest_api.basic-api.id
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

resource "aws_api_gateway_request_validator" "request-validator-resource-one" {
  name                  = "RequestValidatorResourceOne"
  rest_api_id           = aws_api_gateway_rest_api.basic-api.id
  validate_request_body = true
}

resource "aws_api_gateway_integration" "resource-one-integration" {
  http_method             = "POST"
  credentials             = aws_iam_role.role-basic-api.arn
  resource_id             = aws_api_gateway_resource.resource-one.id
  rest_api_id             = aws_api_gateway_rest_api.basic-api.id
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
    aws_api_gateway_resource.resource-one,
    aws_api_gateway_method.resource-one-method
  ]
}

resource "aws_api_gateway_integration_response" "resource-one-integration-response" {
  http_method = aws_api_gateway_method.resource-one-method.http_method
  resource_id = aws_api_gateway_resource.resource-one.id
  rest_api_id = aws_api_gateway_rest_api.basic-api.id
  status_code = aws_api_gateway_method_response.resource-one-integration-method-response.status_code

  response_templates = {
    "application/json" = "{\"message\": \"Resource one sending message!\"}"
  }

  depends_on = [aws_api_gateway_integration.resource-one-integration]
}

resource "aws_api_gateway_method_response" "resource-one-integration-method-response" {
  http_method = aws_api_gateway_method.resource-one-method.http_method
  resource_id = aws_api_gateway_resource.resource-one.id
  rest_api_id = aws_api_gateway_rest_api.basic-api.id
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }
}

# RESOURCE TWO CONFIGURATION

resource "aws_api_gateway_resource" "resource-two" {
  parent_id   = aws_api_gateway_rest_api.basic-api.root_resource_id
  path_part   = "two"
  rest_api_id = aws_api_gateway_rest_api.basic-api.id
}

resource "aws_api_gateway_method" "resource-two-method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.resource-two.id
  rest_api_id   = aws_api_gateway_rest_api.basic-api.id
}

resource "aws_api_gateway_integration" "resource-two-integration" {
  http_method             = "POST"
  credentials             = aws_iam_role.role-basic-api.arn
  resource_id             = aws_api_gateway_resource.resource-two.id
  rest_api_id             = aws_api_gateway_rest_api.basic-api.id
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

  depends_on = [aws_api_gateway_method.resource-two-method, aws_api_gateway_resource.resource-two]
}

resource "aws_api_gateway_integration_response" "resource-two-integration-response" {
  http_method = aws_api_gateway_method.resource-two-method.http_method
  resource_id = aws_api_gateway_resource.resource-two.id
  rest_api_id = aws_api_gateway_rest_api.basic-api.id
  status_code = aws_api_gateway_method_response.resource-two-integration-method-response.status_code

  response_templates = {
    "application/json" = "{\"message\": \"Resource two sending message!\"}"
  }

  depends_on = [aws_api_gateway_integration.resource-two-integration]
}

resource "aws_api_gateway_method_response" "resource-two-integration-method-response" {
  http_method = aws_api_gateway_method.resource-two-method.http_method
  resource_id = aws_api_gateway_resource.resource-two.id
  rest_api_id = aws_api_gateway_rest_api.basic-api.id
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }
}

# DEPLOYMENT SECTION

resource "aws_api_gateway_deployment" "deployment-basic-api" {
  depends_on = [
    aws_api_gateway_integration.resource-one-integration,
    aws_api_gateway_integration.resource-two-integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.basic-api.id
  stage_name  = "dev"
}