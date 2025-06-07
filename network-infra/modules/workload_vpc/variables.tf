variable "env" {
  description = "Environment name (e.g., dev, uat, prod)"
  type        = string
  default     = "dev"
}

variable "product" {
  description = "Product name"
  type        = string
  default     = "cxi"
}

variable "vpc_cidr" {
  description = "CIDR blocks for the workload, ingress, and egress VPCs."
  type        = string
  default     = "172.16.0.0/16"
}

variable "tgw_id" {
  description = "Transit Gateway ID"
  type        = string
}

variable "tgw_egress_attachment_id" {
  description = "Transit Egress Attachment ID"
  type        = string
}

variable "tgw_ingress_attachment_id" {
  description = "Transit Egress Attachment ID"
  type        = string
}

variable "vpc_ids" {
  description = "Map of VPC IDs with keys 'ingress' and 'egress'"
  type        = map(string)
}

variable "tgw_ingress_rt_id" {
  description = "TGW Ingress RT ID"
  type        = string
}

variable "tgw_egress_rt_id" {
  description = "TGW Egress RT ID"
  type        = string
}

variable "egress_public_rt_id" {
  description = "TGW Egress RT ID"
  type        = string
}

variable "ingress_vpc_cidr" {
  description = "CIDR of Ingress"
  type        = string
  default     = "192.168.10.0/24"
}
