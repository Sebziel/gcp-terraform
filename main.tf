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

module "influx" {
  source = "./modules/terra-influx"
  project_id = var.project_id
  region = var.region
}

