variable "aws_region" {}
variable "aws_profile" {}
data "aws_availability_zones" "available" {}
variable "vpc_cidr" {}

variable "cidrs" {
  type = "map"
}

variable "auth_lista" {
  type = "list"
}

variable "elb2_lista" {
  type = "list"
}

variable "instance_type_bastion" {}
variable "bastion_ami" {}
