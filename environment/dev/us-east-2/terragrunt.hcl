include "root" {
  path   = find_in_parent_folders("common.hcl")
}
terraform {
  source = "../../../modules/network"

  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]

    required_var_files = ["${get_parent_terragrunt_dir()}/configuration/dev/us-east-2/network/terraform.tfvars"]
  }
}