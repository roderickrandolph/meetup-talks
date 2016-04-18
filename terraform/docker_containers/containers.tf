provider "docker" {
    host      = "${var.docker_host}"
    cert_path = "${var.docker_cert_path}"
}

resource "docker_image" "docker_image" {
    count = "${var.container_count}"
    name  = "${var.image}"

    keep_updated = true

    lifecycle {
        create_before_destroy = true
    }
}

resource "docker_container" "docker_container" {
    count      = "${var.container_count}"
    depends_on = ["docker_image.docker_image"]

    name  = "${replace(var.image, "/:|\\//", "_")}_${var.host_port}_${count.index}"
    image = "${var.image}"

    env = [
        "affinity:container!=${replace(var.image, "/:|\\//", "_")}_${var.host_port}*"
    ]

    ports {
        external = "${var.host_port}"
        internal = "${var.container_port}"
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_elb" "elb" {
    depends_on = ["docker_container.docker_container"]

    name    = "app-elb"
    subnets = ["${compact(split(",", var.subnets))}"]

    security_groups = ["${compact(split(",", var.security_groups))}"]
    cross_zone_load_balancing = true
    connection_draining = true

    listener {
        lb_port     = "80"
        lb_protocol = "http"

        instance_port     = "${var.host_port}"
        instance_protocol = "http"
    }

    health_check {
        timeout  = 3
        target   = "TCP:${var.host_port}"
        interval = 5

        healthy_threshold   = 2
        unhealthy_threshold = 2
    }

    tags {
        Name = "app-elb"
    }
}

provider "dnsimple" {}

resource "dnsimple_record" "dns_record" {
    name   = "${element(split(".", var.app_domain_name), 0)}"
    domain = "${element(split(".", var.app_domain_name), 1)}.${element(split(".", var.app_domain_name), 2)}"
    value  = "${aws_elb.elb.dns_name}"
    type   = "CNAME"
    ttl    = 60
}
