aws_profile = "superhero"
aws_region  = "eu-west-1"
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

auth_lista = [ "213.30.18.1/32", "85.246.181.205/32",
              "10.20.32.0/19"]

auth_lista2 = [ "213.30.18.1/32", "85.246.181.205/32",
              "10.20.32.0/19", "10.0.0.0/16"]

elb2_lista = [ "10.0.3.0/24", "10.0.4.0/24"]

elb_ext_1 = "8022"
elb_ext_2 = "8024"
chave = "CelFocus_Lab001"
null_list = "0.0.0.0/0"
instance_type_bastion = "t2.micro"
bastion_ami = "ami-0c21ae4a3bd190229"
instance_type_front = "t3.large"
instance_type_web = "t3.xlarge"
instance_type_ansible = "t2.large"
front_ami = "ami-0dfe9c96aee4dc8d6"
