output "vm-external-ip" {
  value       = google_compute_address.vm-external-address.address
  description = "Influx vm ip, influx address"
}