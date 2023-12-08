remote_state {
  backend = "s3"
  config = {
    bucket         = "uow-terraform-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "uow-terraform-state-lock-dynamo"
    region         = "us-east-2"
  }
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