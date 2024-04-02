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
      // Ephemeral public IP
    }
  }

  metadata_startup_script = templatefile("${path.module}/influx-startup.sh.tftpl", { ipaddr = "123.123.123.123" , token ="sygoniummonstera"})
}