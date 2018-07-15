variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}

variable "aws_access_key" {
  description = "AWS Access key here or provide as env variable or creds file"
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS Secret key here or provide as env variable or creds file"
  default     = ""
}
