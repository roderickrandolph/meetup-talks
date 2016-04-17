variable "aws_region" {
    description = "The AWS region"
}

variable "availability_zones" {
    description = "Comma delimited list of AWS availability zone letters"
    default = "b,c,d,e"
}
