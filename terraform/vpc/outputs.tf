output "public_subnet_ids" {
    value = "${join(",", aws_subnet.public.*.id)}"
}

output "public_subnet_cidr_blocks" {
    value = "${join(",", aws_subnet.public.*.cidr_block)}"
}

output "security_group_id" {
    value = "${aws_security_group.main.id}"
}
