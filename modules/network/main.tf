resource "aws_vpc" "main_pvc" {
  cidr_block = var.vcn_cidr

  tags = {
    "name" = "MainPVC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main_pvc.id
  cidr_block = var.pubnet_cidr

  availability_zone = var.pubnet_az
  
  tags = {
    "name" = "PublicSubnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main_pvc.id
  cidr_block = var.privnet_cidr
  availability_zone = var.privnet_az
  
  tags = {
    "name" = "PrivateSubnet"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_pvc.id

  tags = {
    "name" = "InternetGateway"
  }
}

resource "aws_route_table" "public_routing_table" {
  vpc_id = aws_vpc.main_pvc.id

  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "InternetRT"
  }
}

resource "aws_route_table_association" "route_table_association" {
  route_table_id = aws_route_table.public_routing_table.id
  subnet_id = aws_subnet.public_subnet.id
  
}