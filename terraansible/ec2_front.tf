###########################################################################
##
## Front instance
##

resource "aws_instance" "wp_front_az1" {
  instance_type               = "${var.instance_type_front}"
  count                       = "1"
  key_name                    = "${var.chave}"
  vpc_security_group_ids      = ["${aws_security_group.wp_front_sg.id}"]
  associate_public_ip_address = false
  private_ip                  = "10.0.3.225"

  #  private_dns                 = "wp-front-az1.eu-central-1.compute.internal"
  user_data = "${file("user-front-data.txt")}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "25"
    delete_on_termination = "true"
  }

  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = 100
    volume_type           = "gp2"
    delete_on_termination = true

    #    snapshot_id = "snap-0a178ac69ad3f119e"
  }

  tags {
    Name = "wp_front_az1"
  }

  ami               = "${var.front_ami}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  subnet_id         = "${aws_subnet.wp_private1_subnet.id}"
}

# ec2 instance

resource "aws_instance" "wp_front_az2" {
  instance_type               = "${var.instance_type_front}"
  count                       = "1"
  key_name                    = "${var.chave}"
  vpc_security_group_ids      = ["${aws_security_group.wp_front_sg.id}"]
  associate_public_ip_address = false
  private_ip                  = "10.0.4.225"

  #  private_dns                 = "wp-front-az1.eu-central-1.compute.internal"
  user_data = "${file("user-front2-data.txt")}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "25"
    delete_on_termination = "true"
  }

  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = 100
    volume_type           = "gp2"
    delete_on_termination = true

    #    snapshot_id = "snap-0a178ac69ad3f119e"
  }

  tags {
    Name = "wp_front_az2"
  }

  ami               = "${var.front_ami}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  subnet_id         = "${aws_subnet.wp_private2_subnet.id}"
}
