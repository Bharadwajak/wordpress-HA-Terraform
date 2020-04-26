

variable "bastion_sg_id" {}
variable "elb_sg_id" {}
variable "public_webservers_sg_id" {}
variable "public_subnet_1" {}
variable "public_subnet_2" {}

variable "private_subnet_1" {}

variable "private_subnet_2" {}



resource "aws_instance" "Web_Proj_bastion" {
subnet_id = "${var.public_subnet_1}"
vpc_security_group_ids = ["${var.bastion_sg_id}"]
associate_public_ip_address = true
ami = "ami-06fcc1f0bc2c8943f"
instance_type = "t2.micro"
key_name = "bastion_key"
}

# resource "aws_instance" "Web_Proj_WebServer1" {
# vpc_security_group_ids = ["${var.public_webservers_sg_id}"]
# subnet_id = "${var.public_subnet_1}"
# ami = "ami-06fcc1f0bc2c8943f"
# instance_type = "t2.micro"
# key_name = "WebServer"

# user_data = <<EOF
#   #!/bin/bash
#   yum update -y
#   yum install httpd -y
#   service httpd start
#   chkconfig httpd on
#   cd /var/www/html
#   echo "<html><body>IP address of this instance: " > index.html
#   curl http://169.254.169.254/latest/meta-data/local-ipv4 >> index.html
#   echo "</body></html>" >> index.html

# EOF
# }

#  output "webserver1_id" {
#  value = "${aws_instance.Web_Proj_WebServer1.id}"
# }


# resource "aws_instance" "Web_Proj_WebServer2" {
# subnet_id = "${var.public_subnet_2}"
# vpc_security_group_ids = ["${var.public_webservers_sg_id}"]
# ami = "ami-06fcc1f0bc2c8943f"
# instance_type = "t2.micro"
# key_name = "WebServer"

# user_data = <<EOF
#   #!/bin/bash
#   yum update -y
#   yum install httpd -y
#   service httpd start
#   chkconfig httpd on
#   cd /var/www/html
#   echo "<html><body>IP address of this instance: " > index.html
#   curl http://169.254.169.254/latest/meta-data/local-ipv4 >> index.html
#   echo "</body></html>" >> index.html
# EOF
# }

# output "webserver2_id" {
# value = "${aws_instance.Web_Proj_WebServer2.id}"
# }