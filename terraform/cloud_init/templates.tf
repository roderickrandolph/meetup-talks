resource "template_file" "swarm_manager" {
    template = "${file(concat(path.module, "/templates/swarm_manager.yml"))}"

    vars {
        ca_pem = "${var.ca_pem}"

        swarm_manager_key_pem  = "${var.swarm_manager_key_pem}"
        swarm_manager_cert_pem = "${var.swarm_manager_cert_pem}"
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "template_file" "swarm_node" {
    template = "${file(concat(path.module, "/templates/swarm_node.yml"))}"

    vars {
        ca_pem    = "${var.ca_pem}"
        consul_ip = "${var.consul_ip}"

        swarm_node_key_pem  = "${var.swarm_node_key_pem}"
        swarm_node_cert_pem = "${var.swarm_node_cert_pem}"
    }

    lifecycle {
        create_before_destroy = true
    }
}
