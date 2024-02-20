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
  priority         = var.webapp_route_priority
  next_hop_gateway = var.next_hop_gateway
  tags             = var.webapp_route_tags
}

resource "google_compute_instance" "custom_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.instance_tags

  boot_disk {
    initialize_params {
      image = var.image
      type  = var.disk_type
      size  = var.disk_size
    }

  }
  network_interface {
    subnetwork = google_compute_subnetwork.webapp_subnet.self_link
    access_config {
      // Ephemeral IP
    }
  }
}

# Create a firewall rule to allow traffic to your application port
resource "google_compute_firewall" "allow_app_traffic" {
  name    = var.allowed_firewall_name
  network = google_compute_network.cloud_vpc.self_link
  allow {
    protocol = var.protocol
    ports    = var.allowed_ports # Specify the port your application listens to
  }
  target_tags   = var.instance_tags
  source_ranges = var.source_ranges # Allow traffic from any IP address on the internet
}

# Create a firewall rule to disallow traffic to SSH port from the internet
resource "google_compute_firewall" "deny_ssh_from_internet" {
  name    = var.denied_firewall_name
  network = google_compute_network.cloud_vpc.self_link

  deny {
    protocol = var.protocol
    ports    = var.denied_ports # SSH port
  }
  target_tags   = var.instance_tags
  source_ranges = var.source_ranges # Deny traffic from any IP address on the internet
}
