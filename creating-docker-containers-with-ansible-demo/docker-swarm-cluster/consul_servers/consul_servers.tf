resource "template_file" "cloud_init" {
  template = "${file(concat(path.module, "/cloud-config.yml"))}"

  vars {
    consul_server_count = "${var.server_count}"
  }
}

resource "aws_instance" "consul_server" {
  count = "${var.server_count}"

  ami             = "${var.ami}"
  instance_type   = "t2.nano"
  security_groups = ["${compact(split(",", var.security_groups))}"]
  subnet_id       = "${element(compact(split(",", var.subnets)), count.index)}"
  private_ip      = "${cidrhost(element(compact(split(",", var.subnet_cidrs)), count.index), 24)}"
  user_data       = "${template_file.cloud_init.rendered}"

  tags {
    Name = "consul-server${count.index}"
  }
}
