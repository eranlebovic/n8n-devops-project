resource "google_container_cluster" "primary" {
  name                = "n8n-cluster"
  location            = "us-central1"
  network             = google_compute_network.vpc_network.name
  enable_autopilot    = true
  deletion_protection = false
}