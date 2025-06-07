# Data source to fetch ingress VPC details
# data "aws_vpc" "ingress" {
#   id = var.vpc_ids["ingress"]
# }

# Workload VPC: Route Table for Private Subnets
resource "aws_route_table" "workload_private_rt" {
  vpc_id = aws_vpc.workload.id
  tags = {
    Name = "${var.product}-${var.env}-workload-main-rt"
  }
}

# Workload VPC: Associate route table with private subnets
resource "aws_route_table_association" "workload_private_subnet_assoc" {
  count          = 2
  subnet_id      = aws_subnet.workload_private_subnets[count.index].id
  route_table_id = aws_route_table.workload_private_rt.id
}

# Workload VPC : Route all outbound traffic to the TGW
resource "aws_route" "egress_to_tgw" {
  route_table_id         = aws_route_table.workload_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.tgw_id
}

# Workload VPC : Route all outbound traffic to the TGW
resource "aws_route" "egress_public_to_tgw" {
  route_table_id         = var.egress_public_rt_id
  destination_cidr_block = aws_vpc.workload.cidr_block
  transit_gateway_id     = var.tgw_id
}

# Workload VPC: TGW Route table
resource "aws_ec2_transit_gateway_route_table" "workload_rt" {
  transit_gateway_id = var.tgw_id
  tags = {
    Name = "${var.product}-${var.env}-workload-rt"
  }
}

# Route Association
resource "aws_ec2_transit_gateway_route_table_association" "workload_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_rt.id
}

# Route Propagations
resource "aws_ec2_transit_gateway_route_table_propagation" "workload_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_rt.id
}

# Workload VPC: TGW route to send 0.0.0.0/0 to egress
resource "aws_ec2_transit_gateway_route" "workload_to_egress" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_rt.id
  transit_gateway_attachment_id  = var.tgw_egress_attachment_id
}

# Workload VPC: TGW route from ingress to workload
resource "aws_ec2_transit_gateway_route" "ingress_to_workload" {
  destination_cidr_block         = aws_vpc.workload.cidr_block
  transit_gateway_route_table_id = var.tgw_ingress_rt_id
  transit_gateway_attachment_id  = var.tgw_ingress_attachment_id
}

# Workload VPC: TGW Back route from workload to ingress
resource "aws_ec2_transit_gateway_route" "workload_to_ingress" {
  destination_cidr_block         = var.ingress_vpc_cidr
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_rt.id
  transit_gateway_attachment_id  = var.tgw_ingress_attachment_id
}

# Workload VPC: TGW Back route from egress to workload
resource "aws_ec2_transit_gateway_route" "egress_to_workload" {
  destination_cidr_block         = aws_vpc.workload.cidr_block
  transit_gateway_route_table_id = var.tgw_egress_rt_id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload.id
}
