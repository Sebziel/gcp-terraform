variable "project_id" {
  type = string
  description = "GCP project ID"
}

variable "image_list" {
  type = list(string)
}

variable "region" {
  type = string
}
