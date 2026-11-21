locals {
  services = [
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "storage.googleapis.com"
  ]
}

resource "google_project_service" "enabled_services" {
  for_each = toset(local.services)

  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}
