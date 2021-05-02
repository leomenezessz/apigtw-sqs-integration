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