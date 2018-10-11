# ec2 jankins instance

resource "aws_instance" "wp_jenkins" {
  instance_type               = "${var.instance_type_web}"
  count                       = "1"
  key_name                    = "CelFocus1"
  vpc_security_group_ids      = ["${aws_security_group.wp_tool_sg.id}"]
  associate_public_ip_address = false
  private_ip                  = "10.0.7.224"

  #  private_dns                 = "wp-front-az1.eu-central-1.compute.internal"
  user_data = "${file("user-jenkins-data.txt")}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "25"

    #   delete_on_termination = "true"
  }

  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = 120
    volume_type           = "gp2"
    delete_on_termination = true

    #    snapshot_id = "snap-0a178ac69ad3f119e"
  }

  tags {
    Name = "wp_jenkins"
  }

  ami               = "${var.front_ami}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  subnet_id         = "${aws_subnet.wp_private5_subnet.id}"
}

# ec2 nagios instance

resource "aws_instance" "wp_nagios" {
  instance_type               = "${var.instance_type_front}"
  count                       = "1"
  key_name                    = "CelFocus1"
  vpc_security_group_ids      = ["${aws_security_group.wp_tool_sg.id}"]
  associate_public_ip_address = false
  private_ip                  = "10.0.7.225"

  #  private_dns                 = "wp-front-az1.eu-central-1.compute.internal"
  user_data = "${file("user-nagios-data.txt")}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "25"

    #   delete_on_termination = "true"
  }

  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = 100
    volume_type           = "gp2"
    delete_on_termination = true

    #    snapshot_id = "snap-0a178ac69ad3f119e"
  }

  tags {
    Name = "wp_nagios"
  }

  ami               = "${var.front_ami}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  subnet_id         = "${aws_subnet.wp_private5_subnet.id}"
}

# ec2 ansible instance

resource "aws_instance" "wp_ansible" {
  instance_type               = "${var.instance_type_ansible}"
  count                       = "1"
  key_name                    = "CelFocus1"
  vpc_security_group_ids      = ["${aws_security_group.wp_tool_sg.id}"]
  associate_public_ip_address = false
  private_ip                  = "10.0.8.225"

  #  private_dns                 = "wp-front-az1.eu-central-1.compute.internal"
  user_data = "${file("user-ansible-data.txt")}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "25"

    #   delete_on_termination = "true"
  }

  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = 70
    volume_type           = "gp2"
    delete_on_termination = false
  }

  tags {
    Name = "wp_ansible"
  }

  ami               = "${var.front_ami}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  subnet_id         = "${aws_subnet.wp_private6_subnet.id}"
}
