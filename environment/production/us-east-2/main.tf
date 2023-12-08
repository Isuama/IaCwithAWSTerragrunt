terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "uow-terraform-state-bucket"
    key            = "production/us-east-2/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "uow-terraform-state-lock-dynamo"
  }
}

module "network" {
    source = "../../../modules/network"
    main_vpc_cidr = var.main_vpc_cidr
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    region_location = var.region_location
}