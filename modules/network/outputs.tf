output "public_subnet_1" {
  value = aws_subnet.public_subnet_1
  description = "Public subnet 1"
}

output "public_subnet_2" {
  value = aws_subnet.public_subnet_2
  description = "Public subnet 2"
}

output "ecs_tasks" {
  value = aws_security_group.ecs_tasks
  description = "ECS tasks list"
}

output "target_group_arn" {
  value = aws_alb_target_group.app
  description = "APRN for ALB"
}

/*output "alb_dns_name" {
  value       = aws_alb.main.dns_name
  description = "DNS name of the ALB"
}*/

output "domain_name" {
  value = aws_alb.main.dns_name
  description = "ALB public endpoint"
}