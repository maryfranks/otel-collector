terraform {
  required_version = "~> 1.13.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.9"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

terraform {
  backend "gcs" {
    # Replace with your globally-unique GCS bucket name, or pass via -backend-config="bucket=..."
    bucket = "TF_STATE_BUCKET"
    prefix = "terraform/state"
  }
}
