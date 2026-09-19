#Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_tags
  }
}

#Create a public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_tags
  }
}

#Create an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = var.internet_gateway_tags
  }
}

#Create a route table and association with the public subnet
resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = var.route_table_tags
  }
}
resource "aws_route_table_association" "routetable" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.routetable.id
}