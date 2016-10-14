variable "server_count" {
  description = "The number of consul servers to create"
}

variable "ami" {
  description = "The AMI to use for the instance"
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
