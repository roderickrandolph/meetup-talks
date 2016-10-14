variable "server_count" {
  description = "The number of swarm managers to create"
}

variable "ami" {
  description = "The AMI to use for the instance"
}

variable "manager_port" {
  description = "The port address for swarm manager to listen on"
  default     = 2376
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
