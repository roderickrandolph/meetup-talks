output "elb_name" {
    value = "${aws_elb.elb.name}"
}

output "dns_name" {
    value = "${dnsimple_record.dns_record.hostname}"
}
