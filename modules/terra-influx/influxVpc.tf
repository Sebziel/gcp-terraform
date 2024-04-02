# VPC
resource "google_compute_network" "influx-vpc" {
  name                    = "influx-${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "influx-subnet" {
  name          = "influx-${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.influx-vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

#FirewallRule
resource "google_compute_firewall" "influx-firewall" {
  name    = "influx-${var.project_id}-firewall"
  network = google_compute_network.influx-vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["8086"]
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

}

resource "google_compute_address" "vm-external-address" {
  name         = "vm-external-address"
  address_type = "EXTERNAL"
  region       = "us-central1"
}