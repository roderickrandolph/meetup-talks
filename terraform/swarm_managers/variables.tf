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

variable "user_data" {
    description = "The user data to provide when launching the instance"
}
