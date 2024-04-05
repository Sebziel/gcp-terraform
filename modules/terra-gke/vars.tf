variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "gcloud_token" {
  description = "gcloud authorization token"
}

variable "manifest_list" {
  type = list(string)
}

provider "google" {
  project = var.project_id
  region  = var.region
}

