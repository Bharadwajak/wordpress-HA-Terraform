provider "aws" {
    region = "us-west-1"
}

module "vpc" {
  source = "./vpc"
}

module "security-groups" {
  wp_vpc_id = "${module.vpc.wp_vpc_id}"
  source = "./vpc/Security-groups"
}

module "instances" {
  public_subnet_1 = "${module.vpc.public_subnet_1}"
  public_subnet_2 = "${module.vpc.public_subnet_2}"
  private_subnet_1 = "${module.vpc.private_subnet_1}"
  private_subnet_2 = "${module.vpc.private_subnet_2}"
  bastion_sg_id = "${module.security-groups.bastion_sg_id}"
  elb_sg_id = "${module.security-groups.elb_sg_id}"
  public_webservers_sg_id = "${module.security-groups.public_webservers_sg_id}"
  source = "./Instances"
}

module "elb" {
  # web_server1_id = "${module.instances.web_server1_id}"
  # web_server2_id = "${module.instances.web_server2_id}"
  wp_vpc_id = "${module.vpc.wp_vpc_id}"
  public_subnet_1 = "${module.vpc.public_subnet_1}"
  public_subnet_2 = "${module.vpc.public_subnet_2}"
  elb_sg_id = "${module.security-groups.elb_sg_id}"
  source = "./elb"
}

module "launch-config" {
  sg_public_webservers = "${module.security-groups.public_webservers_sg_id}"
source = "./asg/launch-config"
}

module "asg" {
  public_subnet_1 = "${module.vpc.public_subnet_1}"
  public_subnet_2 = "${module.vpc.public_subnet_2}"
  elb_id = "${module.elb.elb_id}"
  target_group_arn = "${module.elb.target_group_arn}"
  launch_config_name = "${module.launch-config.launch_configuration_name}"
  source = "./asg/asg"
}




