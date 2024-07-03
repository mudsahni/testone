provider "google" {
  project     = var.project_id
  region      = var.region
}

resource "google_cloud_run_service" "demo_app" {
  name     = "demo-app"
  location = var.region

  template {
    spec {
      containers {
        image = var.image_name
        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_project_iam_member" "run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "allUsers"
}

output "cloud_run_url" {
  value = google_cloud_run_service.demo_app.status[0].url
}
