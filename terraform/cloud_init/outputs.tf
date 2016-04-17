output "swarm_manager_rendered" {
    value = "${template_file.swarm_manager.rendered}"
}

output "swarm_node_rendered" {
    value = "${template_file.swarm_node.rendered}"
}
