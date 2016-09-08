variable "aws_region" {
  description = "The AWS region"
}

variable "subnet_count" {
  description = "The number of subnets to create"
}

variable "availability_zones" {
  description = "Comma delimited list of AWS availability zone letters"
  default     = "b,c,d,e"
}
