eks_version = "1.26"
eks_name = "demo"
subnet_ids = ""
node_groups = {
  geenral = {
    capacity_type = "ON_DEMAND"
    instance_types = ["t3a.xlarge"]
    scaling_config = {
      desired_size = 1
      max_size = 2
      min_size = 0
    }
  }
}