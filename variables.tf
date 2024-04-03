variable "project" {
  description = "GCP project name"
  default     = "csye6225-dev-414521"
}

variable "region" {
  description = "GCP region"
  default     = "us-east1"
}

variable "network_name" {
  description = "Name of the Google Compute Engine network"
  default     = "csye6225-network"
}
variable "webapp_subnet_name" {
  description = "Name of the subnet for webapp"
  default     = "webapp"
}

variable "db_subnet_name" {
  description = "Name of the subnet for db"
  default     = "db"
}

variable "webapp_rout_name" {
  description = "Name of the internet gateway route for webapp"
  default     = "webapp-route"
}

variable "webapp_subnet_cidr" {
  description = "CIDR range for the webapp subnet"
  default     = "192.168.1.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR range for the db subnet"
  default     = "192.168.2.0/24"
}

variable "network_routing_mode" {
  description = "Network routing mode"
  default     = "REGIONAL"
}

variable "webapp_route_dest_range" {
  description = "Destination IP range for the webapp route"
  default     = "0.0.0.0/0"
}

variable "webapp_route_priority" {
  description = "Priority for the webapp route"
  default     = 1000
}

variable "webapp_route_tags" {
  description = "Tags for the webapp route"
  default     = ["webapp-subnet"]
}

variable "next_hop_gateway" {
  description = "Next hop gateway for the route"
  default     = "default-internet-gateway"
}

variable "instance_name" {
  default = "centos-image-instance"
}

variable "protocol" {
  default = "tcp"
}

variable "machine_type" {
  default = "e2-medium"
}

variable "zone" {
  default = "us-east1-b"
}

variable "image" {
  default = "projects/csye6225-dev-414521/global/images/centos-1712171612"
}

variable "disk_type" {
  default = "pd-balanced"
}

variable "disk_size" {
  default = 100
}

variable "allowed_ports" {
  default = ["8080"] # Add more ports as needed
}

variable "denied_ports" {
  default = ["22"] # Add more ports as needed
}

variable "source_ranges" {
  default = ["0.0.0.0/0"]
}

variable "instance_tags" {
  default = ["webapp"]
}

variable "allowed_firewall_name" {
  default = "allow-app-traffic"
}

variable "denied_firewall_name" {
  default = "deny-ssh-from-internet"
}

variable "stack_type" {
  default = "IPV4_ONLY"
}

variable "network_tier" {
  default = "PREMIUM"
}

variable "queue_count" {
  default = 0
}

variable "database_tier" {
  description = "The tier of the Cloud SQL database instance"
  type        = string
  default     = "db-f1-micro"
}

variable "database_disk_type" {
  description = "The type of disk for the Cloud SQL database instance"
  type        = string
  default     = "pd-ssd"
}

variable "database_disk_size" {
  description = "The size of the disk for the Cloud SQL database instance"
  type        = number
  default     = 100
}

variable "database_version" {
  description = "The db version for the Cloud SQL database instance"
  type        = string
  default     = "POSTGRES_15"
}

variable "database_edition" {
  description = "The db edition for the Cloud SQL database instance"
  type        = string
  default     = "ENTERPRISE"
}

variable "database_environment" {
  description = "The db environment for the Cloud SQL database instance"
  type        = string
  default     = "dev"
}

variable "ipv4_flag_db" {
  default = false
}

variable "deletion_protection_flag" {
  default = false
}

variable "database_name" {
  type    = string
  default = "webapp"
}

variable "private_ip_address_name" {
  description = "The name of the global address"
  default     = "private-ip-address"
}

variable "private_ip_address_purpose" {
  description = "The purpose of the address"
  default     = "VPC_PEERING"
}

variable "private_ip_address_type" {
  description = "The type of address"
  default     = "INTERNAL"
}

variable "private_ip_address_prefix_length" {
  description = "The prefix length for the IP address"
  default     = 24
}

variable "private_ip_address" {
  description = "The specific IP address"
  default     = "10.0.1.0"
}

variable "networking_connection_service" {
  default = "servicenetworking.googleapis.com"
}

variable "password_length" {
  description = "The length of the random password"
  default     = 8
}

variable "password_special" {
  description = "Include special characters in the random password"
  default     = false
}

variable "password_override_special" {
  description = "Override the default special characters for the random password"
  default     = "!#$%&*()-_=+[]{}<>:?"
}

variable "username_length" {
  description = "The length of the random username"
  default     = 8
}

variable "username_special" {
  description = "Include special characters in the random username"
  default     = true
}

variable "username_override_special" {
  description = "Override the default special characters for the random username"
  default     = "/@£$"
}

variable "db_name_suffix_length" {
  description = "The length of the random database name suffix"
  default     = 3
}

variable "db_name_suffix_special" {
  description = "Include special characters in the random database name suffix"
  default     = false
}

variable "db_name_suffix_upper" {
  description = "Include uppercase letters in the random database name suffix"
  default     = false
}

variable "dns_record_name" {
  description = "The name of the DNS record."
  type        = string
  default     = "cloudnish.me."
}

variable "dns_record_type" {
  description = "The type of DNS record (e.g., A, CNAME, etc.)."
  type        = string
  default     = "A"
}

variable "dns_record_ttl" {
  description = "The TTL (Time To Live) value for the DNS record."
  type        = number
  default     = 300
}

variable "dns_managed_zone" {
  description = "The managed zone where the DNS record is hosted."
  type        = string
  default     = "cloudnish"
}

variable "logging_admin_role" {
  description = "The role for logging admin."
  type        = string
  default     = "roles/logging.admin"
}

variable "metric_writer_role" {
  description = "The role for monitoring metric writer."
  type        = string
  default     = "roles/monitoring.metricWriter"
}

variable "deletion_policy" {
  description = "The deletion policy for the networking connection."
  type        = string
  default     = "ABANDON"
}

variable "db_user_name" {
  description = "The name of the SQL user."
  type        = string
  default     = "webapp"
}

variable "availability_type" {
  description = "The availability type for the Cloud SQL instance."
  type        = string
  default     = "REGIONAL"
}

variable "logging_service_account_name" {
  type    = string
  default = "logging-service-account"
}

variable "pubsub_publisher_binding_role" {
  type    = string
  default = "roles/pubsub.publisher"
}

variable "cloud_function_account_name" {
  type    = string
  default = "cloud-function-account"
}

variable "cloud_function_account_display_name" {
  type    = string
  default = "Cloud Function Service Account"
}

variable "pubsub_subscriber_role" {
  description = "Pub/Sub Subscriber role"
  default     = "roles/pubsub.subscriber"
}

variable "object_viewer_role" {
  description = "Storage Object Viewer role"
  default     = "roles/storage.objectViewer"
}

variable "cloud_functions_developer_role" {
  description = "Cloud Functions Developer role"
  default     = "roles/cloudfunctions.developer"
}

variable "storage_object_admin_role" {
  description = "Storage Object Admin role"
  default     = "roles/storage.objectAdmin"
}

variable "function_name" {
  description = "Name of the Cloud Function"
  default     = "gcf-function"
}

variable "function_description" {
  description = "Description of the Cloud Function"
  default     = "email delivery function"
}

variable "function_runtime" {
  description = "Runtime environment for the Cloud Function"
  default     = "java17"
}

variable "function_entry_point" {
  description = "Entry point class or method for the Cloud Function"
  default     = "gcfv2pubsub.PubSubFunction"
}

variable "function_max_instance_count" {
  description = "Maximum number of instances for the Cloud Function"
  default     = 3
}

variable "function_min_instance_count" {
  description = "Minimum number of instances for the Cloud Function"
  default     = 1
}

variable "function_available_memory" {
  description = "Available memory for each instance of the Cloud Function"
  default     = "256Mi"
}

variable "function_timeout_seconds" {
  description = "Timeout duration (in seconds) for the Cloud Function"
  default     = 60
}

variable "function_max_instance_request_concurrency" {
  description = "Maximum number of concurrent requests per instance for the Cloud Function"
  default     = 1
}

variable "function_available_cpu" {
  description = "Available CPU for each instance of the Cloud Function"
  default     = "167m"
}

variable "function_api_key" {
  description = "API key for the Cloud Function"
  default     = "8681e2ca40b80860ade66544d58da93e-309b0ef4-7dab6103"
}

variable "function_vpc_connector_egress_settings" {
  description = "Egress settings for the VPC connector"
  default     = "PRIVATE_RANGES_ONLY"
}

variable "function_ingress_settings" {
  description = "Ingress settings for the Cloud Function"
  default     = "ALLOW_ALL"
}

variable "function_all_traffic_on_latest_revision" {
  description = "Whether to route all traffic to the latest revision of the Cloud Function"
  default     = true
}

variable "function_event_type" {
  description = "Event type for the Cloud Function trigger"
  default     = "google.cloud.pubsub.topic.v1.messagePublished"
}

variable "function_retry_policy" {
  description = "Retry policy for the Cloud Function trigger"
  default     = "RETRY_POLICY_DO_NOT_RETRY"
}

variable "connector_name" {
  description = "Name of the VPC Access Connector"
  default     = "vpc-connector-serverless"
}

variable "connector_ip_cidr_range" {
  description = "IP CIDR range for the VPC Access Connector"
  default     = "10.8.0.0/28"
}

variable "object_name" {
  description = "Name of the storage bucket object"
  default     = "gcf-function/function-source.zip"
}

variable "object_source_path" {
  description = "Local path to the zipped function source code"
  default     = "../serverless/function-source.zip"
}

variable "topic_message_retention_duration" {
  type    = string
  default = "604800s"
}

variable "topic_name" {
  type    = string
  default = "function-topic"
}

variable "service_port" {
  default = 8080
}

variable "health_check_name" {
  description = "The name of the health check."
  type        = string
  default     = "webapp-health-check"
}

variable "check_interval_sec" {
  description = "The number of seconds between each health check request."
  type        = number
  default     = 15
}

variable "timeout_sec" {
  description = "How long to wait for a health check response, in seconds."
  type        = number
  default     = 15
}

variable "healthy_threshold" {
  description = "The number of consecutive successful health checks before considering an instance as healthy."
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "The number of consecutive failed health checks before considering an instance as unhealthy."
  type        = number
  default     = 3
}

variable "http_health_check_port" {
  description = "The port number to use for the health check."
  type        = string
  default     = "8080"
}

variable "http_health_check_request_path" {
  description = "The path portion of the URL that the health check requests are sent to."
  type        = string
  default     = "/healthz"
}

variable "log_config_enable" {
  description = "Whether to enable logging for this health check."
  type        = bool
  default     = true
}

variable "autoscaler_name" {
  description = "The name of the autoscaler."
  type        = string
  default     = "webapp-autoscaler"
}

variable "min_replicas" {
  description = "The minimum number of replicas that the autoscaler can scale down to."
  type        = number
  default     = 3
}

variable "max_replicas" {
  description = "The maximum number of replicas that the autoscaler can scale up to."
  type        = number
  default     = 9
}

variable "cooldown_period" {
  description = "The number of seconds that the autoscaler should wait before considering further scale operations after the previous one completes."
  type        = number
  default     = 180
}

variable "cpu_utilization_target" {
  description = "The target CPU utilization ratio."
  type        = number
  default     = 0.05
}

variable "instance_group_manager_name" {
  description = "The name of the instance group manager."
  type        = string
  default     = "webapp-instance-group-manager"
}

variable "base_instance_name" {
  description = "The base instance name for the instances in the managed instance group."
  type        = string
  default     = "webapp-instance"
}

variable "distribution_policy_zones" {
  description = "A list of zones that instances in the managed instance group can be distributed across."
  type        = list(string)
  default = ["us-east1-b", "us-east1-c", "us-east1-d"]
}

variable "named_port_name" {
  type        = string
  default = "http"
}

variable "named_port_number" {
  type        = string
  default = "8080"
}

variable "auto_healing_delay" {
  default = 180
}

variable "source_ranges_lb_firewall" {
  description = "The list of source IP ranges allowed to access the resources."
  type        = list(string)
  default     = ["130.211.0.0/22", "35.191.0.0/16"]
}

variable "firewall_name" {
  description = "The name of the firewall rule."
  type        = string
  default     = "allow-lb-traffic"
}

variable "lb_name" {
  description = "The name of the load balancer."
  type        = string
  default     = "group-http-lb"
}

variable "managed_ssl_certificate_domains" {
  description = "List of managed SSL certificate domains."
  type        = list(string)
  default     = ["cloudnish.me"]
}

variable "ssl_enabled" {
  description = "Whether SSL is enabled for the load balancer."
  type        = bool
  default     = true
}

variable "http_forward_enabled" {
  description = "Whether HTTP forwarding is enabled for the load balancer."
  type        = bool
  default     = false
}

variable "load_balancing_scheme" {
  description = "The load balancing scheme for the load balancer."
  type        = string
  default     = "EXTERNAL_MANAGED"
}

variable "health_check_request_path" {
  description = "The request path for health checks."
  type        = string
  default     = "/healthz"
}

variable "log_config_enabled" {
  description = "Whether logging is enabled."
  type        = bool
  default     = true
}

variable "log_config_sample_rate" {
  description = "The sample rate for logging."
  type        = number
  default     = 1.0
}

variable "iap_enabled" {
  description = "Whether Identity-Aware Proxy (IAP) is enabled."
  type        = bool
  default     = false
}

variable "timeout_seconds" {
  description = "The timeout for the health check in seconds."
  type        = number
  default     = 15
}

variable "enable_cdn" {
  description = "Whether to enable content delivery network (CDN)."
  type        = bool
  default     = false
}

variable "lb_backend_protocol" {
  type        = string
  default     = "HTTP"
}