# Dedicated runtime identity attached to the e2-micro instance
resource "google_service_account" "otel_sa" {
  account_id   = "otel-collector-sa"
  display_name = "OTel Collector VM Runtime Service Account"
  description  = "Dedicated runtime identity for e2-micro telemetry host"
}

# Grant runtime access to the Grafana admin password secret
resource "google_secret_manager_secret_iam_member" "grafana_access" {
  secret_id = google_secret_manager_secret.grafana_admin_password.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.otel_sa.email}"
}

# Grant runtime access to the Cloudflare Tunnel token secret
resource "google_secret_manager_secret_iam_member" "tunnel_access" {
  secret_id = google_secret_manager_secret.cloudflare_tunnel_token.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.otel_sa.email}"
}
