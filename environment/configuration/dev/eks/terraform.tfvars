eks_version = "1.26"
eks_name = "demo"
node_groups = {
  general = {
    capacity_type = "ON_DEMAND"
    instance_types = ["t3.medium"]
    scaling_config = {
      desired_size = 1
      max_size = 1
      min_size = 0
    }
  }
}

#run below command to connect to k8s
#aws eks update-kubeconfig  --name dev-demo --region us-east-2