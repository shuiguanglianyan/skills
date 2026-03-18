output "cluster_id" {
  description = "VKE cluster id"
  value       = volcengine_vke_cluster.this.id
}

output "kubeconfig_public" {
  description = "Public kubeconfig content"
  value       = volcengine_vke_cluster.this.kubeconfig_public
  sensitive   = true
}

output "kubeconfig_private" {
  description = "Private kubeconfig content"
  value       = volcengine_vke_cluster.this.kubeconfig_private
  sensitive   = true
}
