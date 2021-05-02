# API GATEWAY ROLE

resource "aws_iam_role" "role_apigateway" {
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

resource "aws_iam_policy" "policy_apigateway_sqs" {
  name = "PolicyApiGatewaySQS"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
        ],
        "Resource":[
              "${aws_cloudwatch_log_group.apigateway_log_group.arn}:*",
              "arn:aws:logs:*:*:log-group:/aws/apigateway/*:*"
        ]
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

# LAMBDA ROLE

resource "aws_iam_role" "role_lambda_sqs" {
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

resource "aws_iam_policy" "policy_lambda" {
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
          "logs:PutLogEvents"
        ],
        "Resource": "${aws_cloudwatch_log_group.hello_lambda_log_group.arn}:*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "sqs:DeleteMessage",
          "sqs:ReceiveMessage",
          "sqs:GetQueueAttributes"
        ],
        "Resource": "${aws_sqs_queue.queue.arn}"
      }
    ]
}
EOF
}

# POLICY ATTACHMENTS

resource "aws_iam_role_policy_attachment" "apigateway_sqs_policy_attachment" {
  role       = aws_iam_role.role_apigateway.name
  policy_arn = aws_iam_policy.policy_apigateway_sqs.arn
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.role_lambda_sqs.name
  policy_arn = aws_iam_policy.policy_lambda.arn
}