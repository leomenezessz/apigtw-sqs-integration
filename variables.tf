variable "credentials" {
  default     = "~/.aws/credentials"
  description = "Credentials Path"
}

variable "region" {
  default     = "us-east-1"
  description = "Default Region"
}

variable "profile" {
  default     = "default"
  description = "Default Profile"
}

variable "lambda_name" {
  default = "hello"
}

variable "apigateway_name" {
  default = "BasicApi"
}

variable "stage_name" {
  default = "dev"
}