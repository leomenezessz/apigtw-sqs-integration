
data "archive_file" "hello_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambdas/hello.py"
  output_path = "${path.module}/lambdas/hello.py.zip"
}

resource "aws_lambda_event_source_mapping" "hello_lambda_sqs_mapping" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_function.hello_lambda.arn
}

resource "aws_lambda_function" "hello_lambda" {
  filename         = data.archive_file.hello_lambda_zip.output_path
  function_name    = var.lambda_name
  role             = aws_iam_role.role_lambda_sqs.arn
  handler          = "hello.handler"
  source_code_hash = filebase64sha256(data.archive_file.hello_lambda_zip.output_path)

  runtime = "python3.8"

  depends_on = [
    aws_cloudwatch_log_group.hello_lambda_log_group,
    aws_iam_role_policy_attachment.lambda_policy_attachment,
  ]
}