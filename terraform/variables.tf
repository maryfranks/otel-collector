# ==============================================================================
# VARIABLES INVENTORY
# ==============================================================================
# Inputs required from terraform.tfvars or CLI:
# - project_id: GCP Project ID string.
# - region: Primary compute and resource region (e.g., "us-central1").
# - zone: Compute zone within always-free tier (e.g., "us-central1-a").
# - tf_state_bucket_name: Unique globally-namespaced GCS bucket name for state.
# - data_disk_name: Identifier for the 20 GB pd-standard disk (default: "persistent-data").
# - tunnel_secret_id: Secret Manager secret ID for the Cloudflare Tunnel token.
# - grafana_secret_id: Secret Manager secret ID for the Grafana admin password.
# ==============================================================================

variable "project_id" {
  description = "The GCP Project ID."
  type        = string
}

variable "region" {
  description = "The GCP Always Free Region."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP Always Free Zone."
  type        = string
  default     = "us-central1-a"
}

variable "tf_state_bucket_name" {
  description = "OpenTofu Remote State GCS Bucket."
  type        = string
}

variable "data_disk_name" {
  description = "Telemetry Data Persistent Disk."
  type        = string
  default     = "persistent-data"
}

variable "tunnel_secret_id" {
  description = "Google Secret Manager secret ID for the Cloudflare Tunnel token."
  type        = string
  default     = "CLOUDFLARE_TUNNEL_SECRET_ID"
}

variable "grafana_secret_id" {
  description = "Google Secret Manager secret ID for the Grafana admin password."
  type        = string
  default     = "GRAFANA_ADMIN_PASSWORD_SECRET_ID"
}
