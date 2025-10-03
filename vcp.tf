resource "google_compute_network" "vpc_network" {
  name                    = "n8n-vpc"
  auto_create_subnetworks = true
  mtu                     = 1460
}