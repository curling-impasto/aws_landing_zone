# Internet Gateway
resource "aws_internet_gateway" "egress_igw" {
  vpc_id = aws_vpc.egress.id
  tags = {
    Name = "${var.product}-egress-igw"
  }
}

# Public IPs
resource "aws_eip" "nat" {
  count  = 2
  domain = "vpc"
  tags = {
    Name = "${var.product}-natgw-ip"
  }
}

# NAT Gateways
resource "aws_nat_gateway" "egress_nat" {
  count         = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.egress_public[count.index].id
  tags = {
    Name = "${var.product}-natgw-${local.azs[count.index]}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "ingress_igw" {
  vpc_id = aws_vpc.ingress.id
  tags = {
    Name = "${var.product}-ingress-igw"
  }
}
