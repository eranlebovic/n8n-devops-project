resource "google_container_cluster" "primary" {
  name     = "n8n-cluster"
  location = "us-central1"
  network  = google_compute_network.vpc_network.name

  # GKE Autopilot configuration for cost-effectiveness
  enable_autopilot = true
}