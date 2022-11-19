#---networking/main.tf

# Create a VPC
resource "aws_vpc" "week21_vpc" {
  cidr_block = var.vpc_cidr_in

  tags = {
    Name = "week21-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.week21_vpc.id

  tags = {
    Name = "week21-igw"
  }
}

# Create NAT Gateway in public subnet 10.0.4.0/24
resource "aws_nat_gateway" "natgw" {
  subnet_id     = aws_subnet.public_subnets[1].id
  allocation_id = aws_eip.nat_eip.id
}

# EIP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

# Public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.week21_vpc.id

  tags = {
    Name = "public-rt"
  }
}

# Private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.week21_vpc.id

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.natgw.id
}

resource "aws_route_table_association" "public_rt_association" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_association" {
  count          = var.private_sn_count
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# Declare the data source for available AZs
data "aws_availability_zones" "available" {}


resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

# Public subnets
resource "aws_subnet" "public_subnets" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.week21_vpc.id
  cidr_block              = var.public_cidrs_in[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]
  tags = {
    Name = "week21-public-subnet-${count.index + 1}"
    Tier = "Public"
  }
}

# Private subnets
resource "aws_subnet" "private_subnets" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.week21_vpc.id
  cidr_block        = var.private_cidrs_in[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "week21-private-subnet-${count.index + 1}"
  }
}