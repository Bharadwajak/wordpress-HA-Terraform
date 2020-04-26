
variable "launch_config_name" {
}
variable "elb_id" {}

variable "public_subnet_1" {}
variable "public_subnet_2" {}

variable "target_group_arn" {
  
}



resource "aws_autoscaling_group" "asg" {
  name = "autoscaling-group"
  launch_configuration = "${var.launch_config_name}"
  desired_capacity = 2
  min_size = 2
  max_size = 6
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true
  vpc_zone_identifier = ["${var.public_subnet_1}","${var.public_subnet_2}"]
  

  #  lifeycle {
  #      create_before_destroy = true
  #  }
}
resource "aws_autoscaling_attachment" "asg_attachment_group" {
  autoscaling_group_name = "${aws_autoscaling_group.asg.id}"
  alb_target_group_arn = "${var.target_group_arn}"
}


