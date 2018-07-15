resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
        Name = "${var.vpc_name}"
    }
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}
