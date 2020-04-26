
  # variable "wp_vpc_id" {}
  # variable "public_subnet_1" {}
  # variable "public_subnet_2" {}
  # variable "private_subnet_1" {}
  # variable "private_subnet_2" {}
  # variable "nat_gw_id" {}
  # variable "igw_id" {}

resource "aws_vpc" "wp-vpc" {
  cidr_block = "10.0.0.0/16"
  tags {
      Name = "WP-VPC"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id = "${aws_vpc.wp-vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1c"
  map_public_ip_on_launch = true

  tags {
      Name = "public_subnet_1c"
  }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id = "${aws_vpc.wp-vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-1b"
  map_public_ip_on_launch = true

  tags {
      Name = "public_subnet_1b"
  }
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id = "${aws_vpc.wp-vpc.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-1b"

  tags {
      Name = "private_subnet_1b"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id = "${aws_vpc.wp-vpc.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-west-1c"

  tags {
      Name = "private_subnet_1c"
  }
}

resource "aws_internet_gateway" "itgw" {
  vpc_id = "${aws_vpc.wp-vpc.id}"

  tags {
      Name = "Web_Proj_1_itgw"
  }
}

# resource "aws_nat_gateway" "natgw" {
#   allocation_id = "${aws_eip.Web_Proj_eip.id}"
#   subnet_id = "${aws_subnet.public_subnet_1b.id}"
# }

# resource "aws_eip" "Web_Proj_eip" {
#   vpc = true
# }

resource "aws_route_table" "rt_public" {
  vpc_id = "${aws_vpc.wp-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.itgw.id}"
  }
  tags {
    Name = "rt_public"
  }
}

# resource "aws_route_table" "rt_private" {
#   vpc_id = "${aws_vpc.wp-vpc.id}"
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = "${aws_nat_gateway.natgw.id}"
#   }
#   tags {
#     Name = "rt_private"
#   }
# }

# resource "aws_route_table_association" "pr-a" {
# subnet_id = "${aws_subnet.private_subnet_1b.id}"
# route_table_id = "${aws_route_table.rt_private.id}"
# }

# resource "aws_route_table_association" "pr-b" {
# subnet_id = "${aws_subnet.private_subnet_1c.id}"
# route_table_id = "${aws_route_table.rt_private.id}"
# }
resource "aws_route_table_association" "pu-a" {
subnet_id = "${aws_subnet.public_subnet_1b.id}"
route_table_id = "${aws_route_table.rt_public.id}"
}

resource "aws_route_table_association" "pu-b" {
subnet_id = "${aws_subnet.public_subnet_1c.id}"
route_table_id = "${aws_route_table.rt_public.id}"
}

output "wp_vpc_id" {
  value = "${aws_vpc.wp-vpc.id}"
}
output "public_subnet_1" {
  value = "${aws_subnet.public_subnet_1b.id}"
}
output "public_subnet_2" {
  value = "${aws_subnet.public_subnet_1c.id}"
}
output "private_subnet_1" {
  value = "${aws_subnet.private_subnet_1b.id}"
}
output "private_subnet_2" {
  value = "${aws_subnet.private_subnet_1c.id}"
}
# output "nat_gw_id" {
#   value = "${aws_nat_gateway.natgw.id}"
# }
output "igw_id" {
  value = "${aws_internet_gateway.itgw.id}"
}