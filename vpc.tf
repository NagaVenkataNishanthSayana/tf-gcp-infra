provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_network" "cloud_vpc" {
  name                            = var.network_name
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
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
