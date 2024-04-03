variable "project_id" {
  type = string
  description = "GCP project ID"
}

variable "image_list" {
  type = list(string)
  description = "list of images to create, have to match folder names in terra-arti module"
}

variable "region" {
  type = string
  description = "GCP region"
}

variable "gke_num_nodes" {
  type = number
  description = "number of gke nodes"
}

variable "gcloud_token" {
  description = "gcloud authorization token"
}