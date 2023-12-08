terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 1 Configure the AWS Provider
provider "aws" {
  region = var.region_location
  profile = "terraform-admin-source-profile"

}

# 2 Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.main_vpc_cidr
  tags = {
    Name = "main"
  }
}

# 3 create subnet
resource "aws_subnet" "public_sb_1" {
vpc_id = aws_vpc.main_vpc.id
cidr_block = var.public_subnet_cidr
tags = {
  Name = "public-subnet-01"
}
}

resource "aws_subnet" "private_sb_1" {
vpc_id = aws_vpc.main_vpc.id
cidr_block = var.private_subnet_cidr
tags = {
  Name = "private-subnet-01"
}
}

# 4 Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

# 5 Create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "internet-gateway"
  }
}

# 6 create route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route"
  }
}

# 7 create route association
resource "aws_route_table_association" "public_tr_a" {
  subnet_id      = aws_subnet.public_sb_1.id
  route_table_id = aws_route_table.public_rt.id
}

# 8 create external/elastic ip
resource "aws_eip" "eip_nat_gw" {
  vpc = true
}

# 9 - create NAT gw
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip_nat_gw.id
  subnet_id = aws_subnet.public_sb_1.id
  tags = {
    Name = "Nat_GW01"
  }
  depends_on = [ aws_internet_gateway.gw ]
}

# 10 create route table - private through NAT gw to the internet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-route"
  }
}

# 11 private create route association
resource "aws_route_table_association" "private_tr_a" {
  subnet_id      = aws_subnet.private_sb_1.id
  route_table_id = aws_route_table.private_rt.id
}
# output "List_of_AZs" {
#   value = data.aws_availability_zones.available
# }