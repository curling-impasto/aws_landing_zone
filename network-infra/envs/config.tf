provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      product = "aws"
      team    = "devops"
    }
  }
}

terraform {

  backend "s3" {
    bucket                 = "landing-zone-tfstate"
    key                    = "network-terraform.tfstate"
    region                 = "us-east-1"
    skip_region_validation = true
  }
}
