provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

#data "aws_availability_zones" "available" {}

#------------IAM---------------- 

#S3_access

resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access"
  role = "${aws_iam_role.s3_access_role.name}"
}

resource "aws_iam_role_policy" "s3_access_policy" {
  name = "s3_access_policy"
  role = "${aws_iam_role.s3_access_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "s3_access_role" {
  name = "s3_access_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
  },
      "Effect": "Allow",
      "Sid": ""
      }
    ]
}
EOF
}

#------------------ VPC ---------------------

resource "aws_vpc" "wp_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "wp_vpc"
  }
}

# internet gateway

resource "aws_internet_gateway" "wp_internet_gateway" {
  vpc_id = "${aws_vpc.wp_vpc.id}"

  tags {
    Name = "wp_igw"
  }
}

# Route tables

resource "aws_route_table" "wp_public_rt" {
  vpc_id = "${aws_vpc.wp_vpc.id}"

  route {
    cidr_block = "${var.null_list}"
    gateway_id = "${aws_internet_gateway.wp_internet_gateway.id}"
  }

  tags {
    Name = "wp_public"
  }
}

resource "aws_default_route_table" "wp_private_rt" {
  default_route_table_id = "${aws_vpc.wp_vpc.default_route_table_id}"

  route {
    cidr_block     = "${var.null_list}"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }

  tags {
    Name = "wp_private"
  }
}

#Subenets

resource "aws_subnet" "wp_public1_subnet" {
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.cidrs["public1"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "wp_public1"
  }
}

resource "aws_subnet" "wp_public2_subnet" {
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.cidrs["public2"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "wp_public2"
  }
}

resource "aws_subnet" "wp_private1_subnet" {
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.cidrs["private1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "wp_private1"
  }
}

resource "aws_subnet" "wp_private2_subnet" {
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.cidrs["private2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "wp_private2"
  }
}

resource "aws_subnet" "wp_private3_subnet" {
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.cidrs["private3"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "wp_private3"
  }
}

resource "aws_subnet" "wp_private4_subnet" {
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.cidrs["private4"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "wp_private4"
  }
}

resource "aws_subnet" "wp_private5_subnet" {
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.cidrs["private5"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "wp_private5"
  }
}

resource "aws_subnet" "wp_private6_subnet" {
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.cidrs["private6"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "wp_private6"
  }
}

resource "aws_subnet" "wp_oracle1_subnet" {
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.cidrs["oracle1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "wp_oracle1"
  }
}

resource "aws_subnet" "wp_oracle2_subnet" {
  vpc_id                  = "${aws_vpc.wp_vpc.id}"
  cidr_block              = "${var.cidrs["oracle2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "wp_oracle2"
  }
}

#-----------------------> NAT GATEWAY 

# A EIP for the NAT gateway.
resource "aws_eip" "wp_nat_eip" {
  vpc = true

  #  depends_on = ["wp_internet_gateway"]
}

# The NAT gateway, attached to the _public_ network.
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.wp_nat_eip.id}"
  subnet_id     = "${aws_subnet.wp_public2_subnet.id}"

  #  depends_on            = ["wp_internet_gateway"]
}

###rds subnet group
resource "aws_db_subnet_group" "wp_rds_subnetgroup" {
  name = "wp_rds_subnetgroup"

  subnet_ids = ["${aws_subnet.wp_oracle1_subnet.id}",
    "${aws_subnet.wp_oracle2_subnet.id}",
  ]

  tags {
    Name = "wp_oracle_sng"
  }
}

# Subnet Associations

resource "aws_route_table_association" "wp_public1_assoc" {
  subnet_id      = "${aws_subnet.wp_public1_subnet.id}"
  route_table_id = "${aws_route_table.wp_public_rt.id}"
}

resource "aws_route_table_association" "wp_public2_assoc" {
  subnet_id      = "${aws_subnet.wp_public2_subnet.id}"
  route_table_id = "${aws_route_table.wp_public_rt.id}"
}

resource "aws_route_table_association" "wp_private1_assoc" {
  subnet_id      = "${aws_subnet.wp_private1_subnet.id}"
  route_table_id = "${aws_default_route_table.wp_private_rt.id}"
}

#############################################################
##
## Security groups
##

#Public SG Bastion

resource "aws_security_group" "wp_bastion_sg" {
  name        = "wp_bastion_sg"
  description = "Used forBastion"
  vpc_id      = "${aws_vpc.wp_vpc.id}"

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.auth_lista}"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.auth_lista2}"]
  }
}

#Public SG ELB1

resource "aws_security_group" "wp_elb1_sg" {
  name        = "wp_elb1_sg"
  description = "Used for public ELB1"
  vpc_id      = "${aws_vpc.wp_vpc.id}"

  #Open POrts

  ingress {
    from_port   = 8022
    to_port     = 8022
    protocol    = "tcp"
    cidr_blocks = ["${var.null_list}"]
  }
  ingress {
    from_port   = 8024
    to_port     = 8024
    protocol    = "tcp"
    cidr_blocks = ["${var.null_list}"]
  }

  #Outbound "public"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.null_list}"]
  }
}

#Private SG ELB2

resource "aws_security_group" "wp_elb2_sg" {
  name        = "wp_elb2_sg"
  description = "Used for private ELB2"
  vpc_id      = "${aws_vpc.wp_vpc.id}"

  #Open Ports

  ingress {
    from_port   = 8022
    to_port     = 8022
    protocol    = "tcp"
    cidr_blocks = ["${var.elb2_lista}"]
  }
  ingress {
    from_port   = 8023
    to_port     = 8023
    protocol    = "tcp"
    cidr_blocks = ["${var.elb2_lista}"]
  }
  ingress {
    from_port   = 8024
    to_port     = 8024
    protocol    = "tcp"
    cidr_blocks = ["${var.elb2_lista}"]
  }
  ingress {
    from_port   = 7023
    to_port     = 7023
    protocol    = "tcp"
    cidr_blocks = ["${var.elb2_lista}"]
  }
  ingress {
    from_port   = 7024
    to_port     = 7024
    protocol    = "tcp"
    cidr_blocks = ["${var.elb2_lista}"]
  }
  ingress {
    from_port   = 7022
    to_port     = 7022
    protocol    = "tcp"
    cidr_blocks = ["${var.elb2_lista}"]
  }

  #Outbound "private elb2"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
}

#Front-End SG

resource "aws_security_group" "wp_front_sg" {
  name        = "wp_front_sg"
  description = "Used FRONT instances"
  vpc_id      = "${aws_vpc.wp_vpc.id}"

  # INBounds

  ingress {
    from_port = 8022
    to_port   = 8022
    protocol  = "tcp"

    security_groups = ["${aws_security_group.wp_elb1_sg.id}"]
  }
  ingress {
    from_port = 8024
    to_port   = 8024
    protocol  = "tcp"

    security_groups = ["${aws_security_group.wp_elb1_sg.id}"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = ["${aws_security_group.wp_bastion_sg.id}",
      "${aws_security_group.wp_tool_sg.id}",
    ]
  }
  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.null_list}"]
  }
}

#Mid-Tear SG

resource "aws_security_group" "wp_mid_sg" {
  name        = "wp_mid_sg"
  description = "Used for ELB2 access"
  vpc_id      = "${aws_vpc.wp_vpc.id}"

  #Open Ports

  ingress {
    from_port = 8022
    to_port   = 8022
    protocol  = "tcp"

    security_groups = ["${aws_security_group.wp_front_sg.id}"]
  }
  ingress {
    from_port = 8023
    to_port   = 8023
    protocol  = "tcp"

    security_groups = ["${aws_security_group.wp_front_sg.id}"]
  }
  ingress {
    from_port = 8024
    to_port   = 8024
    protocol  = "tcp"

    security_groups = ["${aws_security_group.wp_front_sg.id}"]
  }
  ingress {
    from_port = 7023
    to_port   = 7023
    protocol  = "tcp"

    security_groups = ["${aws_security_group.wp_front_sg.id}"]
  }
  ingress {
    from_port = 7024
    to_port   = 7024
    protocol  = "tcp"

    security_groups = ["${aws_security_group.wp_front_sg.id}"]
  }
  ingress {
    from_port = 7022
    to_port   = 7022
    protocol  = "tcp"

    security_groups = ["${aws_security_group.wp_front_sg.id}"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = ["${aws_security_group.wp_bastion_sg.id}",
      "${aws_security_group.wp_tool_sg.id}",
    ]
  }

  #Outbound

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.null_list}"]
  }
}

#Management SG

resource "aws_security_group" "wp_tool_sg" {
  name        = "wp_tool_sg"
  description = "Used for manage instances"
  vpc_id      = "${aws_vpc.wp_vpc.id}"

  # INBounds

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.null_list}"]
  }
}

#DB Security Group

resource "aws_security_group" "wp_db_sg" {
  name        = "wp_db_sg"
  description = "Used for DB instances"
  vpc_id      = "${aws_vpc.wp_vpc.id}"

  # DB access security group

  ingress {
    from_port = 1521
    to_port   = 1521
    protocol  = "tcp"

    security_groups = ["${aws_security_group.wp_mid_sg.id}"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = ["${aws_security_group.wp_bastion_sg.id}",
      "${aws_security_group.wp_tool_sg.id}",
    ]
  }
  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.null_list}"]
  }
}
