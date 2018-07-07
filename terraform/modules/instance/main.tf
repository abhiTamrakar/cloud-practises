resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_security_group" "elb" {
  name        = "airflow-elb"
  description = "Used for airflow app"
  vpc_id      = "${var.vpcid}"

  to_port     = 80
  ingress {
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion-security" {
  name        = "bastion_security"
  description = "used in bastion security"
  vpc_id      = "${var.vpcid}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  connection {
    user = "ubuntu"

  }

  instance_type = "${var.instance_size}"
  ami = "${lookup(var.aws_amis, var.awsregion)}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion_security.id}"]
  subnet_id = "${var.publicsubnetid}"
  associate_public_ip_address =  true

  tags {
    Name = "bastion-instance"
  }
}

resource "aws_security_group" "airflow_sec_grp" {
  name        = "airflow_security"
  description = "used in airflow security"
  vpc_id      = "${var.vpcid}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.bastion.public_ip}"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "web" {
  name = "airflow-elb"

  subnets         = ["${var.publicsubnetid}"]
  security_groups = ["${aws_security_group.elb.id}"]
  instances       = ["${aws_instance.web.id}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_instance" "web" {
  connection {
    user = "ubuntu"

  }

  instance_type = "${var.instance_size}"

  ami = "${lookup(var.aws_amis, var.awsregion)}"

  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.airflow_sec_grp.id}"]

  subnet_id = "${var.privatesubnetid}"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update"
    ]
  }

  tags {
    Name = "airflow-instance"
  }
}

output "lb_address" {
  value = "${aws_elb.web.dns_name}"
}
