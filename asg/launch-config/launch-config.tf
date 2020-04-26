
variable "sg_public_webservers" {
  
}


resource "aws_launch_configuration" "launch_config" {
  name = "web_config"
  image_id = "ami-06fcc1f0bc2c8943f"
  instance_type = "t2.micro"
  security_groups = ["${var.sg_public_webservers}"]
  key_name = "WebServer"

  user_data = <<EOF
  #!/bin/bash
  yum update -y
  yum install httpd -y
  service httpd start
  chkconfig httpd on
  cd /var/www/html
  echo "<html><body>IP address of this instance: " > index.html
  curl http://169.254.169.254/latest/meta-data/public-ipv4 >> index.html
  echo "</body></html>" >> index.html
  
  EOF

}

output "launch_configuration_name" {
  value = "${aws_launch_configuration.launch_config.name}"
}

