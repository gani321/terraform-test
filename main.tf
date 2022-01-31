provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAXNVYN5UADEI7AC4C"
  secret_key = "OVDom2pQRaPfW88ufNQYGCVl"
}

resource "aws_vpc" "vpc" {
  cidr_block       = 10.0.0.0/16
  instance_tenancy = "default"
  enable_dns_support = "true"

  tags = {
    Name = defaut 

  }
}