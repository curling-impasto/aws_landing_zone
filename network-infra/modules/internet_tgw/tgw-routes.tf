# TGW Ingress Route Table
resource "aws_ec2_transit_gateway_route_table" "ingress_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "${var.product}-ingress-rt"
  }
}

# Route Association
resource "aws_ec2_transit_gateway_route_table_association" "ingress_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.ingress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ingress_rt.id
}

# Route Propagations
resource "aws_ec2_transit_gateway_route_table_propagation" "ingress_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.ingress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ingress_rt.id
}


# TGW Egress Route Table
resource "aws_ec2_transit_gateway_route_table" "egress_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "${var.product}-egress-rt"
  }
}

# Route Association
resource "aws_ec2_transit_gateway_route_table_association" "egress_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.egress_rt.id
}

# Route Propagations
resource "aws_ec2_transit_gateway_route_table_propagation" "egress_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.egress_rt.id
}

resource "aws_route" "send_back_to_tgw" {
  count                  = 2
  route_table_id         = var.egress_rt_ids[count.index]
  destination_cidr_block = "172.16.0.0/12"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}
