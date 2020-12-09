output "master_ipv4" {
  description = "Map of private ipv4 to public ipv4 for masters"
  value       = [hcloud_server.nodes.*.ipv4_address]
}

output "worker_ipv4" {
  description = "Map of private ipv4 to public ipv4 for workers"
  value       = [hcloud_server.nodesw.*.ipv4_address]
}

output "lb_public_ipv4" {
  description = "Map of private ipv4 to public ipv4 for lb"
  value       = [hcloud_load_balancer.load-balancer.ipv4]
}
