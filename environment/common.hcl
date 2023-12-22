generate "provide"{
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    provider "aws" {
  region = "us-east-2"
  profile = "terraform-admin-source-profile"
  }
  EOF
}
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "uow-terraform-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "uow-terraform-state-lock-dynamo"
  }
}
EOF
}
