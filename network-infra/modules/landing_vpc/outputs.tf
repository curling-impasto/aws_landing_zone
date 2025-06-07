output "vpc_ids" {
  value = {
    ingress = aws_vpc.ingress.id
    egress  = aws_vpc.egress.id
  }
}

# Ingress VPC Public Subnets
output "ingress_public_subnet_ids" {
  description = "IDs of the public subnets in the ingress VPC"
  value       = aws_subnet.ingress_subnets[*].id
}

# Egress VPC Private Subnets
output "egress_private_subnet_ids" {
  description = "IDs of the private subnets in the egress VPC"
  value       = aws_subnet.egress_private[*].id
}

# Output Transit Gateway VPC Attachment IDs
output "egress_rt_ids" {
  description = "Egress RT IDs"
  value       = [for rt in aws_route_table.egress_private_rt : rt.id]
}

# Output Transit Gateway VPC Attachment IDs
output "egress_public_rt_id" {
  description = "Egress Public RT ID"
  value       = aws_route_table.egress_public_rt.id
}
