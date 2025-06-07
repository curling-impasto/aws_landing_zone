variable "env" {
  description = "Environment name (e.g., dev, uat, prod)"
  type        = string
}

variable "product" {
  description = "product name"
  type        = string
  default     = "cxi"
}

# Worklaod SG ID
variable "workload_sg_id" {
  description = "IDs of the Security Group in workload VPC"
  type        = string
}

# Egress VPC Private Subnets
variable "private_subnet_ids" {
  description = "IDs of the private subnets in the egress VPC"
  type        = list(string)
}

variable "instance_family" {
  description = "EC2 Instance Family"
  type        = string
  default     = "t3a.small"
}

variable "disk_size" {
  description = "EBS Disk Size"
  type        = number
  default     = 40
}

variable "aws_ami_id" {
  description = "EC2 AMI ID"
  type        = string
}
