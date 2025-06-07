locals {
  azs                      = ["us-east-1a", "us-east-1c"]
  workload_private_subnets = cidrsubnets(var.vpc_cidr, 6, 6) # /22 subnets
}

data "aws_region" "current" {}

# Workload VPC
resource "aws_vpc" "workload" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.product}-${var.env}-workload-vpc"
  }
}

# Workload VPC: Private Subnets
resource "aws_subnet" "workload_private_subnets" {
  count             = 2
  vpc_id            = aws_vpc.workload.id
  cidr_block        = local.workload_private_subnets[count.index]
  availability_zone = local.azs[count.index]
  tags = {
    Name = "${var.product}-${var.env}-workload-${local.azs[count.index]}"
  }
}

# Workload VPC: TGW attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "workload" {
  subnet_ids                                      = aws_subnet.workload_private_subnets[*].id
  transit_gateway_id                              = var.tgw_id
  vpc_id                                          = aws_vpc.workload.id
  transit_gateway_default_route_table_association = false
  tags = {
    Name = "${var.product}-${var.env}-workload-vpc"
  }
}

# Workload VPC: General Security Group
resource "aws_security_group" "allow_tcp_within_subnets" {
  name        = "${var.product}-${var.env}-workload-sg"
  description = "Allow TCP from VPC subnets"
  vpc_id      = aws_vpc.workload.id

  tags = {
    Name = "${var.product}-${var.env}-workload-sg"
  }
}

resource "aws_security_group_rule" "allow_all_tcp_from_subnets" {
  count             = length(local.workload_private_subnets)
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [local.workload_private_subnets[count.index]]
  security_group_id = aws_security_group.allow_tcp_within_subnets.id
  description       = "Allow all TCP from subnet ${local.workload_private_subnets[count.index]}"
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_tcp_within_subnets.id
  description       = "Allow all outbound traffic"
}
