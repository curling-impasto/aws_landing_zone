locals {
  azs             = ["us-east-1a", "us-east-1c"]
  ingress_subnets = cidrsubnets(var.vpc_cidrs["ingress"], 2, 2)
  egress_subnets  = cidrsubnets(var.vpc_cidrs["egress"], 4, 4, 4, 4)
}

resource "aws_vpc" "ingress" {
  cidr_block = var.vpc_cidrs["ingress"]
  tags = {
    Name = "${var.product}-ingress-vpc"
  }
}

resource "aws_vpc" "egress" {
  cidr_block = var.vpc_cidrs["egress"]
  tags = {
    Name = "${var.product}-egress-vpc"
  }
}

# Ingress VPC: Public Subnets
resource "aws_subnet" "ingress_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.ingress.id
  cidr_block              = local.ingress_subnets[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.product}-ingress-public-${local.azs[count.index]}"
  }
}

# Public Subnets
resource "aws_subnet" "egress_public" {
  count = 2

  vpc_id                  = aws_vpc.egress.id
  cidr_block              = local.egress_subnets[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.product}-egress-public-${local.azs[count.index]}"
    Type = "public"
  }
}

# Private Subnets
resource "aws_subnet" "egress_private" {
  count = 2

  vpc_id                  = aws_vpc.egress.id
  cidr_block              = local.egress_subnets[count.index + 2]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.product}-egress-private-${local.azs[count.index]}"
    Type = "private"
  }
}
