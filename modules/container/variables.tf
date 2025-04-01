variable "ecs_cluster_name" {
    type = string
    description = "ECS Cluster Name"
}

variable "public_subnet_1" {
    type = string
    description = "Public subnet 1 id"
}

variable "public_subnet_2" {
    type = string
    description = "Public subnet 2 id"
}

variable "ecs_tasks" {
    type = string
    description = "Security Group"
}

variable "target_group_arn" {
    type = string
    description = "Target group ARN"
}