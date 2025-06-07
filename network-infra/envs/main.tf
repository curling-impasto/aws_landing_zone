# TF to create Landing Zone

# Egress, Ingress VPC
module "landing_vpc" {
  source = "../modules/landing_vpc"
}

# Create TGW and Attach to Egress, Ingress VPC
module "internet_tgw" {
  source         = "../modules/internet_tgw"
  tgw_asn        = "65312"
  ingress_public = module.landing_vpc.ingress_public_subnet_ids
  egress_private = module.landing_vpc.egress_private_subnet_ids
  vpc_ids        = module.landing_vpc.vpc_ids
  egress_rt_ids  = module.landing_vpc.egress_rt_ids

  depends_on = [module.landing_vpc]
}

# Create Dev VPC and Attach to TGW
module "dev_vpc" {
  source                    = "../modules/workload_vpc"
  env                       = "dev"
  vpc_cidr                  = "172.16.0.0/16"
  tgw_id                    = module.internet_tgw.transit_gateway_id
  tgw_egress_attachment_id  = module.internet_tgw.egress_attachment_id
  tgw_ingress_attachment_id = module.internet_tgw.ingress_attachment_id
  tgw_ingress_rt_id         = module.internet_tgw.ingress_rt_id
  tgw_egress_rt_id          = module.internet_tgw.egress_rt_id
  vpc_ids                   = module.landing_vpc.vpc_ids
  egress_public_rt_id       = module.landing_vpc.egress_public_rt_id

  depends_on = [module.internet_tgw, module.landing_vpc]
}

module "dev_ops_ec2" {
  source             = "../modules/ops_ec2"
  env                = "dev"
  aws_ami_id         = "ami-0f88e80871fd81e91"
  workload_sg_id     = module.dev_vpc.workload_sg_id
  private_subnet_ids = module.dev_vpc.workload_private_subnet_ids
}
