variable "image" {
    description = "The name of the docker image"
}

variable "container_count" {
    description = "The number of containers to create"
}

variable "host_port" {
    description = "The port number to expose on the docker host"
}

variable "container_port" {
    description = "The internal port number the container is listening on"
}

variable "subnets" {
    description = "List of comma delimited subnet ids"
}

variable "security_groups" {
    description = "List of comma delimited security group ids"
}

variable "dns_domain_name" {
    description = "A custom domain name to create as a DNS alias to the application load balancer"
}
