#VM Instance definition
resource "google_compute_instance" "influx-vm" {
  name         = "influx-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240307b"
      size = 10
      type = "pd-balanced"
    }
  }

  network_interface {
    network = google_compute_network.influx-vpc.name
    subnetwork = google_compute_subnetwork.influx-subnet.name
    access_config {
      nat_ip = google_compute_address.vm-external-address.address
    }
  }
  #Unable to pass external IP as it requires for the resource to be finished first, can't 'self reference.
  metadata_startup_script = templatefile("${path.module}/script-templates/influx-startup.sh.tftpl", { ipaddr = google_compute_address.vm-external-address.address , token ="sygoniummonstera"})
}

resource "google_compute_instance" "petclinic-app" {
  name         = "petclinic-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  service_account {
    email = "cli-service-account-1@${var.project_id}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240307b"
      size = 10
      type = "pd-balanced"
    }
  }

  network_interface {
    network = google_compute_network.influx-vpc.name
    subnetwork = google_compute_subnetwork.influx-subnet.name
    access_config {
      #ephemeral public ip
    }
  }
  #Unable to pass external IP as it requires for the resource to be finished first, can't 'self reference.
  metadata_startup_script = templatefile("${path.module}/script-templates/petclinic-startup.sh.tftpl", {project_id = "${var.project_id}", ipaddr = google_compute_address.vm-external-address.address , token ="sygoniummonstera"})
}


resource "google_storage_bucket" "static" {
 name          = "${var.project_id}-sz-storage"
 location      = "US"
 storage_class = "STANDARD"
 uniform_bucket_level_access = true
}

