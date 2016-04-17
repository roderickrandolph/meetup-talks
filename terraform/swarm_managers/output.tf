output "consul_ip" {
    value = "${element(aws_eip.swarm_manager_eip.*.private_ip, 0)}"
}

output "docker_address" {
    value = "tcp://${dnsimple_record.swarm_manager.hostname}:${var.manager_port}"
}
