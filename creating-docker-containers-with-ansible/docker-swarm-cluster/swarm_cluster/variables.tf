variable "server_count" {
  description = "The number of docker hosts to create"
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

variable "load_balancers" {
  description = "List of comma delimited load balancer names"
  default     = ""
}
