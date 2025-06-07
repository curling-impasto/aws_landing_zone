# Output Transit Gateway ID
output "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.tgw.id
}

# Output Transit Gateway VPC Attachment IDs
output "ingress_attachment_id" {
  description = "Ingress TGW VPC Attachment ID"
  value       = aws_ec2_transit_gateway_vpc_attachment.ingress.id
}

output "egress_attachment_id" {
  description = "Egress TGW VPC Attachment ID"
  value       = aws_ec2_transit_gateway_vpc_attachment.egress.id
}

# Output Transit Gateway VPC Attachment IDs
output "ingress_rt_id" {
  description = "Ingress TGW RT ID"
  value       = aws_ec2_transit_gateway_route_table.ingress_rt.id
}

# Output Transit Gateway VPC Attachment IDs
output "egress_rt_id" {
  description = "Egress TGW RT ID"
  value       = aws_ec2_transit_gateway_route_table.egress_rt.id
}
