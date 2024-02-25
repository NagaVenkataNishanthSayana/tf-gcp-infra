provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_network" "cloud_vpc" {
  name                            = var.network_name
  auto_create_subnetworks         = false
  routing_mode                    = var.network_routing_mode
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "webapp_subnet" {
  name          = var.webapp_subnet_name
  network       = google_compute_network.cloud_vpc.self_link
  ip_cidr_range = var.webapp_subnet_cidr
  region        = var.region
}

resource "google_compute_subnetwork" "db_subnet" {
  name          = var.db_subnet_name
  network       = google_compute_network.cloud_vpc.self_link
  ip_cidr_range = var.db_subnet_cidr
  region        = var.region
}

resource "google_compute_route" "webapp_route" {
  name             = var.webapp_rout_name
  network          = google_compute_network.cloud_vpc.self_link
  dest_range       = var.webapp_route_dest_range
  next_hop_gateway = var.next_hop_gateway
}

# Create Compute Engine Instance
resource "google_compute_instance" "webapp_instance" {
  name         = "centos-instance"
  machine_type = "e2-micro"
  zone         = "us-east1-b"
  tags         = var.instance_tags
  boot_disk {
    initialize_params {
      image = "projects/csye6225-dev-414521/global/images/centos-1708538201"
      size  = 100
      type  = "pd-balanced"
    }
  }

  network_interface {
    access_config {
      network_tier = var.network_tier
    }

    queue_count = 0
    stack_type  = var.stack_type
    network     = google_compute_network.cloud_vpc.self_link
    subnetwork  = google_compute_subnetwork.webapp_subnet.self_link
  }
}

# Add firewall rule
resource "google_compute_firewall" "webapp_firewall" {
  name        = var.allowed_firewall_name
  network     = google_compute_network.cloud_vpc.name
  target_tags = var.instance_tags

  allow {
    protocol = var.protocol
    ports    = var.allowed_ports
  }

  source_ranges = var.source_ranges
}

resource "google_compute_firewall" "ssh_block_firewall" {
  name        = var.denied_firewall_name
  network     = google_compute_network.cloud_vpc.name
  target_tags = var.instance_tags

  deny {
    protocol = var.protocol
    ports    = var.denied_ports
  }

  source_ranges = var.source_ranges
}
