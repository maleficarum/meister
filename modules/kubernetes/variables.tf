variable "cluster_location" {
  type        = string
  description = "Location (AZ) for the cluster"
}

variable "main_network" {
  type = string
}

variable "subnetwork" {
  type = string
}