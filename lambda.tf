
data "archive_file" "basic_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambdas/hello-one.py"
  output_path = "${path.module}/lambdas/hello-one.py.zip"
}

resource "aws_lambda_event_source_mapping" "lambda_queue_mapping" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_function.basic_lambda.arn
}

resource "aws_lambda_function" "basic_lambda" {
  filename         = data.archive_file.basic_lambda.output_path
  function_name    = "basic-lambda"
  role             = aws_iam_role.role_lambdas.arn
  handler          = "hello-one.handler"
  source_code_hash = filebase64sha256(data.archive_file.basic_lambda.output_path)

  runtime = "python3.8"
}