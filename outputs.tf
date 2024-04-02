output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value = module.kubernetesCluster.kubernetes_cluster_name
  description = "GKE cluster name"
}

output "kubernetes_cluster_host" {
  value = module.kubernetesCluster.kubernetes_cluster_host
  description = "Cluster Host"
}

output "influx-external-ip" {
  value = module.influx.vm-external-ip
  description = "Cluster Host"
}