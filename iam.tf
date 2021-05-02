# API GATEWAY ROLE

resource "aws_iam_role" "role-basic-api" {
  name = "BasicApiRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# API GATEWAY POLICY

resource "aws_iam_policy" "policy-basic-api-queue" {
  name = "PolicyBasicApiQueue"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:GetLogEvents"
        ],
        "Resource": "${aws_api_gateway_rest_api.basic-api.arn}"
      },
      {
        "Effect": "Allow",
        "Action": [
          "sqs:SendMessage"
        ],
        "Resource": "${aws_sqs_queue.queue.arn}"
      }
    ]
}
EOF
}

# LAMBDAS ROLE

resource "aws_iam_role" "role_lambdas" {
  name = "LambdasRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# LAMBDA POLICY

resource "aws_iam_policy" "policy-lambda-queue" {
  name = "PolicyQueueLambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:GetLogEvents"
        ],
        "Resource": "${aws_lambda_function.basic_lambda.arn}"
      },
      {
        "Effect": "Allow",
        "Action": [
          "sqs:*"
        ],
        "Resource": "${aws_sqs_queue.queue.arn}"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "basic-api-queue-policy-attachment" {
  role       = aws_iam_role.role-basic-api.name
  policy_arn = aws_iam_policy.policy-basic-api-queue.arn
}

resource "aws_iam_role_policy_attachment" "lambda-queue-policy-attachment" {
  role       = aws_iam_role.role_lambdas.name
  policy_arn = aws_iam_policy.policy-lambda-queue.arn
}