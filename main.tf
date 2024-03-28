module "artifactory" {
  source = "./modules/terra-arti"
  project_id = var.project_id
  image_list = var.image_list
  region = var.region
}

module "kubernetesCluster" {
  source = "./modules/terra-gke"
  project_id = var.project_id
  gke_num_nodes = var.gke_num_nodes
  region = var.region
}

output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_custer_name" {
  value = module.kubernetesCluster.kubernetes_cluster_name
  description = "GKE cluster name"
}

output "kubernetes_cluster_host" {
  value = module.kubernetesCluster.kubernetes_cluster_host
  description = "Cluster Host"
}