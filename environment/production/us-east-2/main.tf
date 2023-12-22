terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "local" {
    path = "dev/vpc/terraform.tfstate"
  }
}

# 1 Configure the AWS Provider
#provider "aws" {
#  region = "network"
#  profile = "terraform-admin-source-profile"
#
#}
module "network" {
    source = "../../../modules/network"
    env = "prod"
    azs = ["us-east-1","us-east-2"]
    main_vpc_cidr = var.main_vpc_cidr
    private_subnets = var.private_subnets
    public_subnets = var.public_subnets
    private_subnet_tags = var.private_subnet_tags
    public_subnet_tags = var.public_subnet_tags
}