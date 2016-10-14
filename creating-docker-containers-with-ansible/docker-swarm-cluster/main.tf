provider "aws" {
  region = "${var.aws_region}"
}

/*module "certificates" {
  source = "certificates"
}*/

module "vpc" {
  source       = "vpc"
  subnet_count = 3
  aws_region   = "${var.aws_region}"
}

/*module "consul_servers" {
  source = "consul_servers"

  server_count    = 3
  ami             = "${var.ami}"
  subnets         = "${module.vpc.public_subnet_ids}"
  subnet_cidrs    = "${module.vpc.public_subnet_cidr_blocks}"
  security_groups = "${module.vpc.security_group_id}"
}*/

module "swarm_managers" {
  source          = "swarm_managers"
  server_count    = 3
  ami             = "${var.ami}"
  subnets         = "${module.vpc.public_subnet_ids}"
  subnet_cidrs    = "${module.vpc.public_subnet_cidr_blocks}"
  security_groups = "${module.vpc.security_group_id}"
  dns_domain_name = "swarm.TripleR.tech"

  /*consul_ip       = "${module.consul_servers.consul_ip}"
        ca_pem          = "${module.certificates.ca_cert_pem}"

        swarm_manager_key_pem  = "${module.certificates.swarm_manager_key_pem}"
        swarm_manager_cert_pem = "${module.certificates.swarm_manager_cert_pem}"*/
}

output "swarm_manager_docker_address" {
  value = "${module.swarm_managers.docker_address}"
}

/*module "swarm_cluster" {
  source       = "swarm_cluster"
  server_count = 5
  ami          = "${var.ami}"
  subnets      = "${module.vpc.public_subnet_ids}"

  security_groups = "${module.vpc.security_group_id}"

  //load_balancers  = "${module.docker_containers.elb_name}"
}*/


/*module "docker_containers" {
  source = "docker_containers"

  image            = "tripler/tracker:latest"
  container_count  = 5
  container_port   = "${var.containers_port}"
  host_port        = "${var.containers_host_port}"
  docker_host      = "${module.swarm_managers.docker_address}"
  subnets          = "${module.vpc.public_subnet_ids}"
  security_groups  = "${module.vpc.security_group_id}"
  app_domain_name  = "tracker.TripleR.tech"
}

output "app_address" {
  value = "${module.docker_containers.dns_name}"
}*/

