provider "google" {
  version = "3.5.0"
  credentials = file("D:\\cloudguild23\\terraform-poc\\cred\\dps-parent-project-86cf6a6130b9.json")
  project = "dps-parent-project"
  region = "us-central1"
  zone = "us-central1-c"
}
resource "google_compute_network" "vpc_network01" {
name = "vpc-net-poc"
}
resource "google_compute_subnetwork" "public-subnetwork01" {
name = "vpc-subnet-poc-01"
ip_cidr_range = "10.2.0.0/16"
region = "us-central1"
network = google_compute_network.vpc_network01.name
}

resource "google_compute_subnetwork" "public-subnetwork02" {
name = "vpc-subnet-poc-02"
ip_cidr_range = "10.3.0.0/16"
region = "us-central1"
network = google_compute_network.vpc_network01.name
}

resource "google_compute_subnetwork" "public-subnetwork03" {
name = "vpc-subnet-poc-03"
ip_cidr_range = "10.4.0.0/16"
region = "us-central1"
network = google_compute_network.vpc_network01.name
}

resource "google_compute_subnetwork" "public-subnetwork04" {
name = "vpc-subnet-poc-04"
ip_cidr_range = "10.5.0.0/16"
region = "us-central1"
network = google_compute_network.vpc_network01.name
}