
resource "aws_internet_gateway" "default" {
  vpc_id = "${var.vpcid}"
}

resource "aws_subnet" "public" {
  vpc_id                  = "${var.vpcid}"
  cidr_block              = "${var.public_subnet}"
  map_public_ip_on_launch = true
  tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "route_public" {
    vpc_id = "${var.vpcid}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "route_public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.route_public.id}"
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public.id}"

  tags {
    Name = "NAT GW"
  }

  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_subnet" "private" {
  vpc_id                  = "${var.vpcid}"
  cidr_block              = "${var.private_subnet}"
}

resource "aws_route_table" "route_private" {
    vpc_id = "${var.vpcid}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.gw.id}"
    }

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_route_table_association" "route_private" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.route_private.id}"
}

output "private_subnet_id" {
   value = "${aws_subnet.private.id}"
}

output "public_subnet_id" {
   value = "${aws_subnet.public.id}"
}
