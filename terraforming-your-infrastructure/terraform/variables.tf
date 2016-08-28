variable "aws_region" {
    default = "us-east-1"
}

variable "ami" {
    default = "ami-08111162" # Amazon Linux AMI (HVM / 64-bit)
}

variable "containers_port" {
    default = 80
}

variable "containers_host_port" {
    default = 8082
}
