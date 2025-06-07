resource "aws_network_acl" "egress" {
  vpc_id     = aws_vpc.egress.id
  subnet_ids = aws_subnet.egress_private[*].id

  tags = {
    Name = "${var.product}-egress-nacl"
  }
}

resource "aws_network_acl_rule" "inbound" {
  for_each = { for rule in var.egress_nacl_rules.inbound : rule.rule_number => rule }

  network_acl_id = aws_network_acl.egress.id
  egress         = false
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  rule_action    = "allow"
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl_rule" "outbound" {
  for_each = { for rule in var.egress_nacl_rules.outbound : rule.rule_number => rule }

  network_acl_id = aws_network_acl.egress.id
  egress         = true
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  rule_action    = "allow"
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}
