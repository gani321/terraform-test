provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAXNVYN5UALSCGKLWW"
  secret_key = "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"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
