output "app_elb_name" {
    value = "${aws_elb.app_elb.name}"
}

output "app_dns_name" {
    value = "${dnsimple_record.app_record.hostname}"
}
