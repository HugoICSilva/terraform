aws_profile = "superhero"
aws_region  = "eu-central-1"
vpc_cidr    = "10.0.0.0/16"
cidrs       = {
 public1  = "10.0.1.0/24"
 public2  = "10.0.2.0/24"
 private1 = "10.0.3.0/24"
 private2 = "10.0.4.0/24"
 private3 = "10.0.5.0/24"
 private4 = "10.0.6.0/24"
 private5 = "10.0.7.0/24"
 private6 = "10.0.8.0/24"
 oracle1  = "10.0.9.0/24"
 oracle2  = "10.0.10.0/24"
}
auth_lista = [ "213.30.18.1/32", "10.20.32.0/19"]
elb2_lista = [ "10.0.3.0/24", "10.0.4.0/24"]
instance_type_bastion = "t2.micro"
bastion_ami = "ami-0e82b8b6afa30f2cd"
