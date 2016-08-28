variable "server_count" {
    description = "The number of docker hosts to create"
}

variable "ami" {
    description = "The AMI to use for the instance"
}

variable "ca_pem" {
    description = "The Certificate Authority (CA) public cert"
}

variable "swarm_node_key_pem" {
    description = "The swarm node's private key"
}

variable "swarm_node_cert_pem" {
    description = "The swarm node's public cert"
}

variable "consul_ip" {
    description = "The IP address of the consul server"
}

variable "subnets" {
    description = "List of comma delimited subnet ids"
}

variable "security_groups" {
    description = "List of comma delimited security group ids"
}

variable "load_balancers" {
    description = "List of comma delimited load balancer names"
    default = ""
}
