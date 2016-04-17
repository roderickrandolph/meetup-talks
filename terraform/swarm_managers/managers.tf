resource "aws_instance" "swarm_manager" {
    count           = 3
    ami             = "ami-08111162" # Amazon Linux AMI (HVM / 64-bit)
    key_name        = "butterfinger"
    instance_type   = "t2.nano"
    security_groups = ["${compact(split(",", var.security_groups))}"]
    subnet_id       = "${element(compact(split(",", var.subnets)), count.index)}"
    private_ip      = "${cidrhost(element(compact(split(",", var.subnet_cidrs)), count.index), 4)}"
    user_data       = "${var.user_data}"

    tags {
        Name = "swarm-manager${count.index}"
    }
}

resource "aws_eip" "swarm_manager_eip" {
    count = 3
    vpc   = true

    instance = "${element(aws_instance.swarm_manager.*.id, count.index)}"
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
