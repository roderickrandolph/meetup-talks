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

variable "user_data" {
    description = "The user data to provide when launching the instance"
}
