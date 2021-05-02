resource "aws_sqs_queue" "queue" {
  name                      = "BasicQueue"
  receive_wait_time_seconds = 5
  message_retention_seconds = 86400
}