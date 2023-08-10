provider "google" {
  project = "<YOUR_PROJECT_ID>"
  region  = "us-central1"
}

resource "google_data_fusion_instance" "data_fusion_instance" {
  name               = "my-data-fusion-instance"
  project            = google_project.project.project_id
  region             = "us-central1"
  zone               = "us-central1-a"
  network            = google_compute_network.default.self_link
  description        = "My Data Fusion instance"
  enable_stackdriver = true
  enable_network_egress_monitoring = true
}

resource "google_compute_network" "default" {
  name                    = "data-fusion-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "data-fusion-subnet"
  network       = google_compute_network.default.self_link
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_project" "project" {
  project_id = "<YOUR_PROJECT_ID>"
}

resource "google_project_service" "datafusion" {
  project = google_project.project.project_id
  service = "datafusion.googleapis.com"
}
