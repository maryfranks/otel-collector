resource "google_compute_instance" "otel_vm" {
  name         = "otel-collector-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["otel-collector"]

  boot_disk {
    auto_delete = true
    initialize_params {
      image = "debian-cloud/debian-12"
      type  = "pd-standard"
      size  = 10
    }
  }

  network_interface {
    network = "default"
    access_config {
      network_tier = "STANDARD"
    }
  }

  service_account {
    email  = google_service_account.otel_sa.email
    scopes = ["cloud-platform"]
  }

  lifecycle {
    ignore_changes = [
      metadata["ssh-keys"],
      attached_disk,
    ]
  }
}

resource "google_compute_attached_disk" "attach_data" {
  disk        = google_compute_disk.persistent_data.id
  instance    = google_compute_instance.otel_vm.id
  device_name = "persistent-data"
  mode        = "READ_WRITE"
}
