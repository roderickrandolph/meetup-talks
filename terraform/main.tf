provider "aws" {
    region = "${var.aws_region}"
}

module "certs" {
    source = "certs"
}

module "vpc" {
    source     = "vpc"
    aws_region = "${var.aws_region}"
}

module "cloud_init" {
    source    = "cloud_init"
    consul_ip = "${module.swarm_managers.consul_ip}"
    ca_pem    = "${module.certs.ca_cert_pem}"

    swarm_node_key_pem  = "${module.certs.swarm_node_key_pem}"
    swarm_node_cert_pem = "${module.certs.swarm_node_cert_pem}"

    swarm_manager_key_pem  = "${module.certs.swarm_manager_key_pem}"
    swarm_manager_cert_pem = "${module.certs.swarm_manager_cert_pem}"
}

module "swarm_managers" {
    source    = "swarm_managers"
    user_data = "${module.cloud_init.swarm_manager_rendered}"
    subnets   = "${module.vpc.public_subnet_ids}"

    subnet_cidrs    = "${module.vpc.public_subnet_cidr_blocks}"
    security_groups = "${module.vpc.security_group_id}"
    dns_domain_name = "${var.swarm_manager_dns_domain_name}"
}

output "swarm_manager_docker_address" {
    value = "${module.swarm_managers.docker_address}"
}

resource "aws_dynamodb_table" "tripler_tracker" {
    name     = "TripleRTracker"
    hash_key = "IPAddress"

    attribute {
        name = "IPAddress"
        type = "S"
    }

    read_capacity  = 10
    write_capacity = 10
}

module "swarm_cluster" {
    source    = "swarm_cluster"
    user_data = "${module.cloud_init.swarm_node_rendered}"
    subnets   = "${module.vpc.public_subnet_ids}"

    security_groups = "${module.vpc.security_group_id}"
    load_balancers  = "${var.app_load_balancers}"
}

module "containers" {
    source          = "containers"
    image           = "tripler/tracker:latest"
    container_count = "${var.containers_count}"
    container_port  = "${var.containers_port}"
    host_port       = "${var.containers_host_port}"
    subnets         = "${module.vpc.public_subnet_ids}"
    security_groups = "${module.vpc.security_group_id}"
    dns_domain_name = "${var.app_dns_domain_name}"
}

output "app_address" {
    value = "${module.containers.app_dns_name}"
}
