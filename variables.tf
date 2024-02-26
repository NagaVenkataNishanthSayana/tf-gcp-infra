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
  default = "n2-standard-2"
}

variable "zone" {
  default = "us-east1-b"
}

variable "image" {
  default = "projects/csye6225-dev-414521/global/images/centos-1708893228"
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
  default     = true
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
