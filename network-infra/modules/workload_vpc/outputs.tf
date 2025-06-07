
output "vpc_id" {
  value = {
    description = "The ID of the workload VPC"
    workload    = aws_vpc.workload.id
  }
}

output "workload_sg_id" {
  description = "The ID of the workload security group"
  value       = aws_security_group.allow_tcp_within_subnets.id
}

output "workload_private_subnet_ids" {
  description = "List of private subnet IDs for the workload VPC"
  value       = aws_subnet.workload_private_subnets[*].id
}
