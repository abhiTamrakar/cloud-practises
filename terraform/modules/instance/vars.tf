variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioner can
connect.
Example: ~/.ssh/terraform.pub
DESCRIPTION
}

variable "key_name" {
  description = "Desired name of AWS key pair"
}

# replace the value here by another ami, current is ubuntu trusty
variable "aws_amis" {
  default = {
    us-west-2 = "ami-7f675e4f"
}
}

variable "instance_size" {
  default = "t2.micro"
}

variable "awsregion" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}

variable "vpcid" {
  description = "vpc id"
}

variable "publicsubnetid" {
  description = "privatesubnetid"
}

variable "privatesubnetid" {
  description = "privatesubnetid"
}
