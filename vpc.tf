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
  depends_on   = [google_sql_database_instance.cloudsql_instance, google_service_account.service_account_instance]
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
          echo "projectID=${var.project}" >> /opt/application.properties
          echo "topicName=${google_pubsub_topic.cloud_trigger_topic.name}" >> /opt/application.properties
        fi
      EOT
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.service_account_instance.email
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
  length  = var.password_length
  special = var.password_special
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

resource "google_service_account" "service_account_instance" {
  account_id   = var.logging_service_account_name
  display_name = var.logging_service_account_name
}

resource "google_project_iam_binding" "logging_admin_binding" {
  project = var.project
  role    = var.logging_admin_role

  members = [
    "serviceAccount:${google_service_account.service_account_instance.email}"
  ]
}

resource "google_project_iam_member" "pubsub_publisher_binding" {
  project = var.project
  role    = var.pubsub_publisher_binding_role
  member  = "serviceAccount:${google_service_account.service_account_instance.email}"
}

resource "google_project_iam_binding" "monitoring_metric_writer_binding" {
  project = var.project
  role    = var.metric_writer_role

  members = [
    "serviceAccount:${google_service_account.service_account_instance.email}"
  ]
}

resource "google_pubsub_topic" "cloud_trigger_topic" {
  name = "functions2-topic"

  message_retention_duration = "86600s"
}

resource "google_storage_bucket" "bucket" {
  name                        = "${var.project}-gcf-source" # Every bucket name must be globally unique
  location                    = var.region
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "object" {
  name   = var.object_name
  bucket = google_storage_bucket.bucket.name
  source = var.object_source_path
}

resource "google_service_account" "cloud_function_account" {
  account_id   = var.cloud_function_account_name
  display_name = var.cloud_function_account_display_name
}

resource "google_project_iam_binding" "function_service_account_binding" {
  project = var.project
  role    = var.pubsub_subscriber_role
  members = [
    "serviceAccount:${google_service_account.cloud_function_account.email}",
  ]
}

resource "google_project_iam_member" "object_viewer_binding" {
  project = var.project
  role    = var.object_viewer_role
  member  = "serviceAccount:${google_service_account.cloud_function_account.email}"
}

resource "google_project_iam_member" "cloud_functions_developer_binding" {
  project = var.project
  role    = var.cloud_functions_developer_role
  member  = "serviceAccount:${google_service_account.cloud_function_account.email}"
}

resource "google_project_iam_member" "storage_object_admin_binding" {
  project = var.project
  role    = var.storage_object_admin_role
  member  = "serviceAccount:${google_service_account.cloud_function_account.email}"
}


resource "google_cloudfunctions2_function" "function" {
  name        = var.function_name
  location    = var.region
  description = var.function_description
  depends_on  = [google_vpc_access_connector.connector, google_sql_database_instance.cloudsql_instance]

  build_config {
    runtime     = var.function_runtime
    entry_point = var.function_entry_point
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object.name
      }
    }
  }

  service_config {
    max_instance_count               = var.function_max_instance_count
    min_instance_count               = var.function_min_instance_count
    available_memory                 = var.function_available_memory
    timeout_seconds                  = var.function_timeout_seconds
    max_instance_request_concurrency = var.function_max_instance_request_concurrency
    available_cpu                    = var.function_available_cpu
    environment_variables = {
      DB_USERNAME   = var.db_user_name
      DB_PASSWORD   = google_sql_user.db_user.password
      API_KEY       = var.function_api_key
      DB_IP_Address = google_sql_database_instance.cloudsql_instance.ip_address.0.ip_address
    }
    vpc_connector                  = google_vpc_access_connector.connector.name
    vpc_connector_egress_settings  = var.function_vpc_connector_egress_settings
    ingress_settings               = var.function_ingress_settings
    all_traffic_on_latest_revision = var.function_all_traffic_on_latest_revision
    service_account_email          = google_service_account.cloud_function_account.email
  }

  event_trigger {
    trigger_region = var.region
    event_type     = var.function_event_type
    pubsub_topic   = google_pubsub_topic.cloud_trigger_topic.id
    retry_policy   = var.function_retry_policy
  }
}

resource "google_vpc_access_connector" "connector" {
  name          = var.connector_name
  ip_cidr_range = var.connector_ip_cidr_range
  network       = google_compute_network.network.name
  region        = var.region
}


