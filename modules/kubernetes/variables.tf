variable "vpc_id" {
    type = string
    description = "Main VPC to locate EKS"
}

variable "subnet_id" {
    type = list(string)
    description = "Subnet ID to locate the nodes"
}

variable "cluster_name" {
    type = string
    description = "Name for the EKS cluster"
}

variable "region" {
    type = string
    description = "Region"
}