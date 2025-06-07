locals {
  ingress_vpc_id = var.vpc_ids["ingress"]
  egress_vpc_id  = var.vpc_ids["egress"]
}

# TGW Internet
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "TGW for shared Landing Zone"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "enable"
  amazon_side_asn                 = var.tgw_asn
  tags = {
    Name = "${var.product}-shared-tgw"
  }
}

# TGW Ingress attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "ingress" {
  subnet_ids                                      = var.ingress_public
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = local.ingress_vpc_id
  transit_gateway_default_route_table_association = false
  tags = {
    Name = "${var.product}-ingress-vpc"
  }
}

# TGW Egress attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "egress" {
  subnet_ids                                      = var.egress_private
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = local.egress_vpc_id
  transit_gateway_default_route_table_association = false
  tags = {
    Name = "${var.product}-egress-vpc"
  }
}
