variable "docker_host" {
    description = "This is the address to the Docker host"
}

variable "docker_cert_path" {
    description = "Path to a directory with certificate information for connecting to the Docker host via TLS"
    default = ""
}

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

variable "app_domain_name" {
    description = "A custom domain name to create as a DNS alias to the application load balancer"
}
