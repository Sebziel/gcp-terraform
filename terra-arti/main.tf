provider "google" {
  project = var.project_id
  region  = "us-central1"
}

resource "null_resource" "activateaApis" {
  provisioner "local-exec" {
    command = "./activateApis.sh"
  }
}

resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
  repository_id = "my-repository"
  description   = "example docker repository"
  format        = "DOCKER"
  depends_on = [ null_resource.activateaApis ]
}

resource "null_resource" "buildAndPushImages" {
  for_each = toset("${var.image_list}")
  depends_on = [ google_artifact_registry_repository.my-repo ]
  provisioner "local-exec" {
    command = "./build_image.sh "
    environment = {
      LOCATION = "${google_artifact_registry_repository.my-repo.location}"
      PROJECT  = "${google_artifact_registry_repository.my-repo.project}"
      REPO_ID  = "${google_artifact_registry_repository.my-repo.repository_id}"
      IMAGE = "${each.value}"

    }
  }
}

#listing image list after pushing to repository
resource "null_resource" "list_images" {
  provisioner "local-exec" {
    command = "gcloud artifacts docker images list ${google_artifact_registry_repository.my-repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.my-repo.repository_id} --format='value(IMAGE)' >> tmp_image_list.txt"
  }
}