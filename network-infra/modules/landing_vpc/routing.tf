# Egress VPC: Public Route Table
resource "aws_route_table" "egress_public_rt" {
  vpc_id = aws_vpc.egress.id

  tags = {
    Name = "${var.product}-egress-public-rt"
  }
}

# Route to IGW
resource "aws_route" "egress_to_igw" {
  route_table_id         = aws_route_table.egress_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.egress_igw.id
}

# Associate all public subnets
resource "aws_route_table_association" "egress_public_subnet_assoc" {
  count          = 2
  subnet_id      = aws_subnet.egress_public[count.index].id
  route_table_id = aws_route_table.egress_public_rt.id
}

# Egress VPC: Private Route Table
resource "aws_route_table" "egress_private_rt" {
  count  = 2
  vpc_id = aws_vpc.egress.id

  tags = {
    Name = "${var.product}-egress-private-${local.azs[count.index]}"
  }
}

# Egress VPC : Route all outbound traffic to the NAT-GW
resource "aws_route" "egress_to_natgw" {
  count                  = 2
  route_table_id         = aws_route_table.egress_private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.egress_nat[count.index].id
}

# Associate all private subnets
resource "aws_route_table_association" "private_subnet_assoc" {
  count          = 2
  subnet_id      = aws_subnet.egress_private[count.index].id
  route_table_id = aws_route_table.egress_private_rt[count.index].id
}
