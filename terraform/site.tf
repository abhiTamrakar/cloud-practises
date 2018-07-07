provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "terraform_example_vpc"
  }

module "network" {
  source = "./modules/network"

  public_subnet = "10.0.1.0/24"
  private_subnet = "10.0.2.0/24"
  vpcid = "${module.vpc.vpc_id}"
}

module "instance" {
  source = "./modules/instance"

  awsregion = "${var.aws_region}"
  instance_size = "t2.micro"
  key_name = "terraform_example_key"
  public_key_path = "~/.ssh/id_rsa.pub"
  vpcid = "${module.vpc.vpc_id}"
  publicsubnetid = "${module.network.public_subnet_id}"
  privatesubnetid = "${module.network.private_subnet_id}"
}

output "lb_dnsname" {
  value = "${module.instance.lb_address}"
}
