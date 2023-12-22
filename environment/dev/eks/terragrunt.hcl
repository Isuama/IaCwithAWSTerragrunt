include "root" {
  path   = find_in_parent_folders("common.hcl")
}

#One or more Amazon EC2 Subnets of [subnet-0223fd05e2a6364b6, subnet-082d7558a2813dd65] for node group general does not automatically assign public IP addresses to instances launched into it. If you want your instances to be assigned a public IP address, then you need to enable auto-assign public IP address for the subnet. See IP addressing in VPC guide: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ip-addressing.html#subnet-public-ip
inputs = {
  subnet_ids = dependency.vpc.outputs.public_subnet_ids
}

terraform {
  source = "../../../modules/eks"

  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh",
      "destroy"
    ]

    required_var_files = ["${get_parent_terragrunt_dir()}/configuration/dev/env.hcl","${get_parent_terragrunt_dir()}/configuration/dev/eks/terraform.tfvars"]
  }
}

dependency "vpc"{
  config_path = "../network"

  mock_outputs = {
    public_subnet_ids = ["subnet-1234", "subnet-5678"]
#    public_subnet_ids = ["subnet-1234", "subnet-5678"]
  }
}