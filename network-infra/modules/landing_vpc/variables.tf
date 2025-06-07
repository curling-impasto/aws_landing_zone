variable "product" {
  description = "Product name"
  type        = string
  default     = "cxi"
}

variable "vpc_cidrs" {
  description = "VPC CIDR blocks for the landing zone VPCs"
  type        = map(string)
  default = {
    ingress = "192.168.10.0/24"
    egress  = "192.168.20.0/24"
  }
}

variable "egress_nacl_rules" {
  description = "NACL rules for egress VPC"
  type = object({
    inbound = list(object({
      rule_number = number
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_block  = string
    }))
    outbound = list(object({
      rule_number = number
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_block  = string
    }))
  })

  default = {
    inbound = [
      {
        rule_number = 100
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0" # Replace with TGW or endpoint CIDR
      },
      {
        rule_number = 110
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 120
        from_port   = 1024
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      }
    ]
    outbound = [
      {
        rule_number = 100
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 110
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 120
        from_port   = 1024
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      }
    ]
  }
}
