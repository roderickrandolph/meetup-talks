variable "server_count" {
    description = "The number of swarm managers to create"
}

variable "ami" {
    description = "The AMI to use for the instance"
}

variable "ca_pem" {
    description = "The Certificate Authority (CA) public cert"
}

variable "swarm_manager_key_pem" {
    description = "The swarm manager's private key"
}

variable "swarm_manager_cert_pem" {
    description = "The swarm manager's public cert"
}

variable "consul_ip" {
    description = "The IP address of the consul server"
}

variable "manager_port" {
    description = "The port address for swarm manager to listen on"
    default = 3376
}

variable "dns_domain_name" {
    description = "A custom domain name to create as a DNS alias to the swarm manager"
}

variable "subnets" {
    description = "List of comma delimited subnet ids"
}

variable "security_groups" {
    description = "List of comma delimited security group ids"
}

variable "subnet_cidrs" {
    description = "List of comma delimited subnet CIDR ranges"
}
