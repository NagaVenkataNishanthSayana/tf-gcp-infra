variable "project" {
  description = "GCP project name"
  default     = "cloud-networking-project"
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
  default     = "10.0.1.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR range for the db subnet"
  default     = "10.0.2.0/24"
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
  default     = ["webapp"]
}

variable "next_hop_gateway" {
  description = "Next hop gateway for the route"
  default     = "default-internet-gateway"
}
