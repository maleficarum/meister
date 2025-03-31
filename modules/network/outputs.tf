output "main_vpc" {
    value = aws_vpc.main_pvc
}

output "subnetwork" {
    value = aws_subnet.public_subnet
}