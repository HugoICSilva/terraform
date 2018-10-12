#------------ Instancias ----------------

# Bastion
resource "aws_instance" "wp_ins_bastion" {
  instance_type               = "${var.instance_type_bastion}"
  key_name                    = "${var.chave}"
  vpc_security_group_ids      = ["${aws_security_group.wp_bastion_sg.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("user-bast-data.txt")}"

  tags {
    Name = "wp_ins_bastion"
  }

  ami               = "${var.bastion_ami}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  subnet_id         = "${aws_subnet.wp_public1_subnet.id}"
}
