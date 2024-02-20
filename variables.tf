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
  default     = "cloudvpc"
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
  default = "projects/csye6225-dev-414521/global/images/centos-1708393438"
}

variable "disk_type" {
  default = "pd-balanced"
}

variable "disk_size" {
  default = 100
}

variable "allowed_ports" {
  default = [8080] # Add more ports as needed
}

variable "denied_ports" {
  default = [22] # Add more ports as needed
}

variable "source_ranges" {
  default = ["0.0.0.0/0"]
}

variable "instance_tags" {
  default = ["web-application"]
}

variable "allowed_firewall_name" {
  default = "allow-app-traffic"
}

variable "denied_firewall_name" {
  default = "deny-ssh-from-internet"
}
