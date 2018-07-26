data "template_file" "swarm_manager" {
  template = "${file("${path.module}/cloud-config.yml")}"
}

resource "aws_instance" "swarm_manager" {
  count                  = "${var.server_count}"
  ami                    = "${var.ami}"
  instance_type          = "t2.large"
  vpc_security_group_ids = ["${compact(split(",", var.security_groups))}"]
  subnet_id              = "${element(compact(split(",", var.subnets)), count.index)}"
  private_ip             = "${cidrhost(element(compact(split(",", var.subnet_cidrs)), count.index), 4)}"
  user_data              = "${data.template_file.swarm_manager.rendered}"
  key_name               = "butterfinger"

  tags {
    Name = "manager${count.index}"
    Role = "docker_swarm_manager"
  }
}

resource "aws_elb" "swarm_manager_elb" {
  name      = "swarm-manager"
  subnets   = ["${compact(split(",", var.subnets))}"]
  instances = ["${aws_instance.swarm_manager.*.id}"]

  connection_draining       = true
  cross_zone_load_balancing = true

  security_groups = ["${compact(split(",", var.security_groups))}"]

  listener {
    lb_port     = "${var.manager_port}"
    lb_protocol = "tcp"

    instance_port     = "${var.manager_port}"
    instance_protocol = "tcp"
  }

  health_check {
    timeout  = 3
    target   = "TCP:${var.manager_port}"
    interval = 5

    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags {
    Name = "swarm-manager"
  }
}

provider "dnsimple" {}

resource "dnsimple_record" "swarm_manager" {
  name   = "${element(split(".", var.dns_domain_name), 0)}"
  domain = "${element(split(".", var.dns_domain_name), 1)}.${element(split(".", var.dns_domain_name), 2)}"
  value  = "${aws_elb.swarm_manager_elb.dns_name}"
  type   = "CNAME"
  ttl    = 60
}
