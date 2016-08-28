output "consul_ip" {
    value = "${element(aws_instance.consul_server.*.private_ip, 0)}"
}
