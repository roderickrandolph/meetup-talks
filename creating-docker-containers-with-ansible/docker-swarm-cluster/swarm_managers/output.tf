output "docker_address" {
  value = "tcp://${dnsimple_record.swarm_manager.hostname}:${var.manager_port}"
}
