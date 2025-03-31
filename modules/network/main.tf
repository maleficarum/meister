data "aws_availability_zones" "available" {}

resource "aws_vpc" "main_pvc" {
  cidr_block = var.vcn_cidr

  tags = {
    "Name" = "MainPVC"
  }
}

resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id     = aws_vpc.main_pvc.id
  cidr_block = cidrsubnet(aws_vpc.main_pvc.cidr_block, 8, count.index)
  map_public_ip_on_launch = true

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    "Name" = "PublicSubnet-${count.index}"
  }
}

/*
resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id            = aws_vpc.main_pvc.id
  cidr_block        = cidrsubnet(aws_vpc.main_pvc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    "Name" = "PrivateSubnet-${count.index}"
  }
}
*/
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_pvc.id

  tags = {
    "Name" = "InternetGateway"
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
  count = 2
  route_table_id = aws_route_table.public_routing_table.id
  subnet_id      = aws_subnet.public_subnet[count.index].id

}