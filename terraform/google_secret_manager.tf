resource "google_secret_manager_secret" "cloudflare_tunnel_token" {
  secret_id = var.tunnel_secret_id

  replication {
    auto {}
  }

  depends_on = [google_project_service.enabled_services]
}

resource "google_secret_manager_secret" "grafana_admin_password" {
  secret_id = var.grafana_secret_id

  replication {
    auto {}
  }

  depends_on = [google_project_service.enabled_services]
}
