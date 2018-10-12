# Create a new load balancer
resource "aws_elb" "elb1" {
  name = "elb1"

  # availability_zones = ["${data.aws_availability_zones.all.names}"]
  # availability_zones = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}"]
  subnets = ["${aws_subnet.wp_public1_subnet.id}", "${aws_subnet.wp_public2_subnet.id}"]

  #  vpc_id             = "${aws_vpc.wp_vpc.id}"
  security_groups = ["${aws_security_group.wp_elb1_sg.id}"]
  internal        = "false"

  listener {
    instance_port     = "${var.elb_ext_1}"
    instance_protocol = "http"
    lb_port           = "${var.elb_ext_1}"
    lb_protocol       = "http"
  }

  listener {
    instance_port     = "${var.elb_ext_2}"
    instance_protocol = "http"
    lb_port           = "${var.elb_ext_2}"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.wp_front_az1.id}", "${aws_instance.wp_front_az2.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "elb1"
  }
}
