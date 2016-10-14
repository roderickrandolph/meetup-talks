variable "aws_region" {
  default = "us-east-1"
}

variable "ami" {
  default = "ami-6d1c2007" # CentOS 7 (x86_64) - with Updates HVM
}

variable "containers_port" {
  default = 80
}

variable "containers_host_port" {
  default = 8082
}
