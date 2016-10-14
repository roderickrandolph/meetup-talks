resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "VPC"
  }
}

resource "aws_internet_gateway" "public_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public_gateway.id}"
  }
}

resource "aws_subnet" "public" {
  count      = "${var.subnet_count}"
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet("10.0.0.0/16", 8, count.index)}"

  availability_zone       = "${var.aws_region}${element(split(",", var.availability_zones), count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "Public Subnet - ${var.aws_region}${element(split(",", var.availability_zones), count.index)}"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = "${var.subnet_count}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route.id}"
}

resource "aws_security_group" "main" {
  name        = "vpc_internet_traffic"
  description = "Allow VPC and internet traffic"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  /*ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }*/

  /*ingress {
      from_port   = 3376
      to_port     = 3376
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }*/

  /*ingress {
    from_port   = 2376
    to_port     = 2376
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }*/

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "vpc_internet_traffic"
  }
}
