variable "product" {
  description = "product name"
  type        = string
  default     = "cxi"
}

variable "tgw_asn" {
  description = "TGW ASN number"
  type        = string
  default     = "64512"
}

# Ingress VPC Public Subnets
variable "ingress_public" {
  description = "IDs of the public subnets in the ingress VPC"
  type        = list(string)
}

# Egress VPC Private Subnets
variable "egress_private" {
  description = "IDs of the private subnets in the egress VPC"
  type        = list(string)
}

variable "vpc_ids" {
  description = "VPC IDs for the landing zone VPCs"
  type        = map(string)
}

# Egress VPC Private Subnets
variable "egress_rt_ids" {
  description = "IDs of the RT of egress private subnets"
  type        = list(string)
}
