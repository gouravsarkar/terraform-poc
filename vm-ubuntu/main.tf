# Define the provider (GCP)
provider "google" {
  version = "3.5.0"
  credentials = file("D:\\cloudguild23\\terraform-poc\\cred\\dps-parent-project-86cf6a6130b9.json")
  project = "dps-parent-project"
  region = "us-central1"
  zone = "us-central1-c"
}

# Define the existing VPC network
data "google_compute_network" "vpc_network" {
  name = "vpc-net-poc-01"
}

# Create a VM instance
resource "google_compute_instance" "vm_instance" {
  name         = "my-vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
    }
  }
  network_interface {
    network       = data.google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}

# Output the public IP of the VM
output "vm_public_ip" {
  value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}
