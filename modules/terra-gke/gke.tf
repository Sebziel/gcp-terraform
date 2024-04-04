# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  #Workload identity is not aplicable for this project as ACG playground is used, which is blocking IAM access to bind the policy.
  #workload_identity_config {
  #  workload_pool = "${var.project_id}.svc.id.goog"
  #}
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    #using default service account with global oath scopes, in order to allow downloading images from repository created in terra-arti subproject.
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      env = var.project_id
    }
    machine_type = "e2-medium"
    disk_size_gb = 30
    tags = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "local_file" "createK8sManifests" {
  for_each = toset("${var.manifest_list}")
  content = templatefile("${path.module}/templates/${each.value}.yaml.tftpl", { project_id = "${var.project_id}", token = "${var.gcloud_token}" })
  filename = "${path.module}/k8s-manifests/${each.value}.yaml"
}
