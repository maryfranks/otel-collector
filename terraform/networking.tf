resource "google_compute_firewall" "allow_ssh" {
  name        = "allow-ssh-ingress"
  network     = "default"
  description = "Allows SSH ingress via GCP Identity-Aware Proxy (IAP)"

  direction     = "INGRESS"
  target_tags   = ["otel-collector"]
  # Standard GCP Identity-Aware Proxy (IAP) IP range
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
