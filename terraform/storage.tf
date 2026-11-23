resource "google_storage_bucket" "tf_state" {
  name                        = var.tf_state_bucket_name
  location                    = var.region
  force_destroy               = false
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      num_newer_versions = 5
      with_state         = "ARCHIVED"
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [google_project_service.enabled_services]
}

resource "google_compute_disk" "persistent_data" {
  name = var.data_disk_name
  type = "pd-standard"
  zone = var.zone
  size = 20

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [google_project_service.enabled_services]
}
