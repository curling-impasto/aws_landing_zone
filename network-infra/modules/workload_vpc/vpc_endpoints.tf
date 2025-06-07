# S3 VPC Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.workload.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = [
    aws_route_table.workload_private_rt.id
  ]
  vpc_endpoint_type = "Gateway"
  lifecycle {
    ignore_changes = [
      service_name
    ]
  }
  tags = {
    Name = "${var.product}-${var.env}-s3-ep"
  }
}

# DynamoDB VPC Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.workload.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  route_table_ids = [
    aws_route_table.workload_private_rt.id
  ]
  vpc_endpoint_type = "Gateway"

  lifecycle {
    ignore_changes = [
      service_name
    ]
  }
  tags = {
    Name = "${var.product}-${var.env}-dynamodb-ep"
  }
}
