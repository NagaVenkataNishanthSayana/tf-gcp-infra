provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_network" "network" {
  name                            = var.network_name
  auto_create_subnetworks         = false
  routing_mode                    = var.network_routing_mode
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "webapp_subnet" {
  name          = var.webapp_subnet_name
  network       = google_compute_network.network.self_link
  ip_cidr_range = var.webapp_subnet_cidr
  region        = var.region
}

resource "google_compute_subnetwork" "db_subnet" {
  name          = var.db_subnet_name
  network       = google_compute_network.network.self_link
  ip_cidr_range = var.db_subnet_cidr
  region        = var.region
}

resource "google_compute_route" "webapp_route" {
  name             = var.webapp_rout_name
  network          = google_compute_network.network.self_link
  dest_range       = var.webapp_route_dest_range
  next_hop_gateway = var.next_hop_gateway
}

# Create Compute Engine Instance
resource "google_compute_instance" "webapp_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.instance_tags
  depends_on   = [google_sql_database_instance.cloudsql_instance, google_service_account.service_account]
  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
      type  = var.disk_type
    }
  }

  network_interface {
    access_config {
      network_tier = var.network_tier
    }

    queue_count = var.queue_count
    stack_type  = var.stack_type
    network     = google_compute_network.network.self_link
    subnetwork  = google_compute_subnetwork.webapp_subnet.self_link
  }
  metadata = {
    startup-script = <<-EOT
        #!/bin/bash
        set -e
        if [ ! -f /opt/application.properties ]; then
          echo "spring.datasource.url=jdbc:postgresql://${google_sql_database_instance.cloudsql_instance.ip_address.0.ip_address}:5432/webapp" >> /opt/application.properties
          echo "spring.datasource.username=webapp" >> /opt/application.properties
          echo "spring.datasource.password=${google_sql_user.db_user.password}" >> /opt/application.properties
          echo "spring.jpa.hibernate.ddl-auto=update" >> /opt/application.properties
          echo "spring.jpa.show-sql=true" >> /opt/application.properties
        fi
      EOT
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.service_account.email
    scopes = ["cloud-platform"]
  }
}

resource "google_dns_record_set" "DNS_Record" {
  name         = var.dns_record_name
  type         = var.dns_record_type
  ttl          = var.dns_record_ttl
  managed_zone = var.dns_managed_zone
  rrdatas      = [google_compute_instance.webapp_instance.network_interface[0].access_config[0].nat_ip]
}

resource "google_compute_firewall" "webapp_firewall" {
  name        = var.allowed_firewall_name
  network     = google_compute_network.network.name
  target_tags = var.instance_tags

  allow {
    protocol = var.protocol
    ports    = var.allowed_ports
  }

  source_ranges = var.source_ranges
}

resource "google_compute_firewall" "ssh_block_firewall" {
  name        = var.denied_firewall_name
  network     = google_compute_network.network.name
  target_tags = var.instance_tags

  deny {
    protocol = var.protocol
    ports    = var.denied_ports
  }

  source_ranges = var.source_ranges
}

resource "google_compute_global_address" "private_ip_address" {
  name          = var.private_ip_address_name
  purpose       = var.private_ip_address_purpose
  address_type  = var.private_ip_address_type
  prefix_length = var.private_ip_address_prefix_length
  address       = var.private_ip_address
  network       = google_compute_network.network.id
}

resource "google_service_networking_connection" "private_connection" {
  network                 = google_compute_network.network.id
  service                 = var.networking_connection_service
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  deletion_policy         = var.deletion_policy
}

resource "random_string" "db_name_suffix" {
  length  = var.db_name_suffix_length
  special = var.db_name_suffix_special
  upper   = var.db_name_suffix_upper
}

resource "google_sql_database_instance" "cloudsql_instance" {
  name                = "cloudsql-instance-${random_string.db_name_suffix.result}"
  region              = var.region
  deletion_protection = var.deletion_protection_flag
  database_version    = var.database_version
  depends_on          = [google_service_networking_connection.private_connection]

  settings {
    availability_type = var.availability_type
    tier              = var.database_tier
    disk_type         = var.database_disk_type
    disk_size         = var.database_disk_size
    edition           = var.database_edition
    user_labels = {
      "env" = var.database_environment
    }
    ip_configuration {
      private_network = google_compute_network.network.self_link
      ipv4_enabled    = var.ipv4_flag_db
    }
  }
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.cloudsql_instance.name
}

resource "random_password" "password" {
  length           = var.password_length
  special          = var.password_special
  override_special = var.password_override_special
}

resource "random_string" "username" {
  length           = var.username_length
  special          = var.username_special
  override_special = var.username_override_special
}

resource "google_sql_user" "db_user" {
  name     = var.db_user_name
  instance = google_sql_database_instance.cloudsql_instance.name
  password = random_password.password.result
}

resource "google_service_account" "service_account" {
  account_id   = var.logging_service_account_name
  display_name = var.logging_service_account_name
}

resource "google_project_iam_binding" "logging_admin_binding" {
  project = var.project
  role    = var.logging_admin_role

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}

resource "google_project_iam_binding" "monitoring_metric_writer_binding" {
  project = var.project
  role    = var.metric_writer_role

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}
