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

variable "auth_lista2" {
  type = "list"
}

variable "elb2_lista" {
  type = "list"
}

variable "elb_ext_1" {}
variable "elb_ext_2" {}
variable "chave" {}
variable "null_list" {}
variable "instance_type_bastion" {}
variable "bastion_ami" {}
variable "instance_type_front" {}
variable "front_ami" {}
variable "instance_type_web" {}
variable "instance_type_ansible" {}
