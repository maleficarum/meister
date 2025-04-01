variable "cidr_block" {
  type        = string
  description = "CIDR block for PVC"
}

variable "public-cidr_block_1" {
  type = string
  description = "CIDR block for public subnet 1"
}

variable "public-cidr_block_2" {
  type = string
  description = "CIDR block for public subnet 2"  
}