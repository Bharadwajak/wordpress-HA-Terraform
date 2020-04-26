
variable "public_subnet_1" {}
variable "public_subnet_2" {}

variable "elb_sg_id" {}

variable "wp_vpc_id" {}




resource "aws_alb" "elb" {
  name = "elb-WebProj"
  subnets = ["${var.public_subnet_1}","${var.public_subnet_2}"]
  security_groups = ["${var.elb_sg_id}"]
  internal = false
  tags {
    Name = "Web_Proj ELB"
  }
}

output "elb_id" {
  value = "${aws_alb.elb.id}"
}



resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_alb.elb.arn}"
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type = "forward"
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name = "webProjtargetgroup"
  port = "80"
  protocol = "HTTP"
  vpc_id = "${var.wp_vpc_id}"
  tags {
    Name = "webproj_tg"
  }
    health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "/index.html"    
    port                = "80"  
  }
}

output "target_group_arn" {
  value = "${aws_alb_target_group.alb_target_group.arn}"
}


# resource "aws_alb_target_group_attachment" "alb_targetgroup_attachment1" {
#   target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
#   target_id = "${var.web_server1_id}"
#   port = 80
# }

# resource "aws_alb_target_group_attachment" "alb_targetgroup_attachment2" {
#   target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
#   target_id = "${var.web_server2_id}"
#   port = 80
# }