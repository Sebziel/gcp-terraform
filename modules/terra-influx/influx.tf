#Not recommended approach, forced by temporary service accounts created by ACG
resource "null_resource" "generate_local_ssh_key" {
  provisioner "local-exec" {
    command = "ssh-keygen -t rsa -f ${path.module}/tmp_key -q -N ''"
  }
}

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
      // Ephemeral public IP
    }
  }
  #Unable to pass external IP as it requires for the resource to be finished first, can't 'self reference got to figure out a workoarund'
  metadata_startup_script = templatefile("${path.module}/influx-startup.sh.tftpl", { ipaddr = "123.123.123.123" , token ="sygoniummonstera"})
}

