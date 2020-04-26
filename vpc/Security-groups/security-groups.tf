variable "wp_vpc_id" {}
# variable "bastion_sg_id" {}
# variable "elb_sg_id" {}
# variable "private_Webservers_sg_id" {}

resource "aws_security_group" "Bastion_SG" {
    name = "Bastion_SG"
    description = "Allows my pc to Bastion Instances"
    vpc_id = "${var.wp_vpc_id}"

    ingress {
      description = "TLS from VPC"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "sgelb" {
    name = "sgelb"
    description = "security group for elb"
    vpc_id = "${var.wp_vpc_id}"

    ingress {
      description = "elb for security group"
      from_port = 80
      to_port = 80
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      description = "Outbound of Private servers for patches"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "public_webservers" {
    name = "Public_Webservers"
    description = "security group for public_webservers"
    vpc_id = "${var.wp_vpc_id}"

    ingress {
      description = "security group for elb"
      from_port = 80
      to_port = 80
      protocol = "TCP"
      security_groups = ["${aws_security_group.sgelb.id}"]
    }

    ingress {
      description = "Security group access of Bastion sg"
      from_port = 0
      to_port = 0
      protocol = "-1"
      security_groups = ["${aws_security_group.Bastion_SG.id}"]
    }

    egress {
      description = "Outbound of Private servers for patches"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

output "bastion_sg_id" {
  value = "${aws_security_group.Bastion_SG.id}"
}

output "elb_sg_id" {
  value = "${aws_security_group.sgelb.id}"
}

output "public_webservers_sg_id" {
  value = "${aws_security_group.public_webservers.id}"
}
