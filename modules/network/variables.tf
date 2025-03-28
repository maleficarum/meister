variable "vcn_cidr" {
    type = string
    description = "CIDR block for PVC"
}

variable "pubnet_cidr" {
    type = string
    description = "CIDR block for public subnet"
}

variable "privnet_cidr" {
    type = string
    description = "CIDR block for private subnet"
}

variable "pubnet_az" {
    type = string
    description = "Availability zone"
}

variable "privnet_az" {
    type = string
    description = "Availability zone"
}