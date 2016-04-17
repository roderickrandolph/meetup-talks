variable "ca_pem" {
    description = "The Certificate Authority (CA) public cert"
}

variable "swarm_manager_key_pem" {
    description = "The swarm manager's private key"
}

variable "swarm_manager_cert_pem" {
    description = "The swarm manager's public cert"
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
