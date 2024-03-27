variable "project_id" {
  type = string
  default = "playground-s-11-4034f0be"
  description = "GCP project ID"
}

variable "image_list" {
  type = list(string)
}
