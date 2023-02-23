resource "google_compute_network" "main" {
  name                    = "main"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
  mtu                     = 1460
}

