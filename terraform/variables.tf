variable "aws_region" {
    default = "us-east-1"
}

variable "swarm_manager_dns_domain_name" {
    default = "swarm.tripler.tech"
}

variable "app_dns_domain_name" {
    default = "tracker.tripler.tech"
}

variable "containers_count" {
    default = 5
}

variable "containers_port" {
    default = 80
}

variable "containers_host_port" {
    default = 8080
}

variable "app_load_balancers" {
    default = "app-elb,"
}
