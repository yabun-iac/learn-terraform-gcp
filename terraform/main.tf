/*
    HCL Hashicorp Configuration Language
    GCP
    1. terraform init
    3. terraform apply
*/

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }

  cloud {
    organization = "udemy-training-iac"

    workspaces {
      name = "udemy-training-iac"
    }
  }
}


provider "google" {
  
  project = "udemyiactraining"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_cloud_run_service" "cloudrun-my-app" {
  name     = "cloudrun-my-app"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/udemyiactraining/my-angular-app-terraform:latest"

        resources {
          limits = {

            cpu    = "2.0"
            memory = "1024Mi"

          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers"
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "policy" {
  location = google_cloud_run_service.cloudrun-my-app.location
  project = google_cloud_run_service.cloudrun-my-app.project
  service = google_cloud_run_service.cloudrun-my-app.name
  policy_data = data.google_iam_policy.admin.policy_data
}
/*resource "google_storage_bucket" "udemy-iac-training" {
  name          = "udemy-iac-training"
  location      = "EU"
  force_destroy = true

  uniform_bucket_level_access = true
}*/
