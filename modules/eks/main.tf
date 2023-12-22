# create role for the cluster
resource "aws_iam_role" eks_cluster_role {
  name               = "${var.env}-${var.eks_name}-eks-cluster-role"
  assume_role_policy = file("${path.module}/policies/assume_cluster_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "eks-cluster-role-policies"{
  for_each = var.cluster_role_iam_policies
  policy_arn = each.value
  role = aws_iam_role.eks_cluster_role.name
}

#resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#  role       = aws_iam_role.eks_cluster_role.name
#}
#
## Optionally, enable Security Groups for Pods
## Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
#resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#  role       = aws_iam_role.eks_cluster_role.name
#}

resource "aws_iam_role" "eks_workerNode_role" {
  name               = "${var.env}-${var.eks_name}-eks-node-role"
  assume_role_policy = file("${path.module}/policies/assume_worker_node_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "worker-node-policies"{
  for_each = var.worker_node_iam_policies
  policy_arn = each.value
  role = aws_iam_role.eks_workerNode_role.name
}

#resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#  role       = aws_iam_role.eks_workerNode_role.name
#}
#
#resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#  role       = aws_iam_role.eks_workerNode_role.name
#}
#
#resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#  role       = aws_iam_role.eks_workerNode_role.name
#}

#EKS
resource "aws_eks_cluster" "this" {
  name     = "${var.env}-${var.eks_name}"
  version = var.eks_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    endpoint_private_access = false # false as no VPN is there
    endpoint_public_access = true
    subnet_ids = var.subnet_ids
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-role-policies
#    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
#    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

#NODE GROUP
resource "aws_eks_node_group" "this" {
  for_each = var.node_groups
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.eks_workerNode_role.arn
  subnet_ids      = [var.subnet_ids[0]]
  capacity_type = each.value.capacity_type
  instance_types = each.value.instance_types

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size
  }

  update_config {
    max_unavailable = 1
  }

  # will help later on with affinity rules
  labels = {
    role = each.key
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.worker-node-policies
#    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
#    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
#    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}



#resource "aws_eks_node_group" "this" {
#  cluster_name    = aws_eks_cluster.this.name
#  node_group_name = "${var.env}-eks-node-group"
#  node_role_arn   = aws_iam_role.eks_workerNode_role.arn
#  #subnet_ids      = ["subnet-0223fd05e2a6364b6"]
#  subnet_ids      = ["${var.subnet_ids[0]}"]
#  capacity_type = "ON_DEMAND"
#  instance_types = ["t3.medium"]
#
#  scaling_config {
#    desired_size = 1
#    max_size     = 1
#    min_size     = 1
#  }
#
#  update_config {
#    max_unavailable = 1
#  }
#
#
#  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#  depends_on = [
#    aws_iam_role_policy_attachment.worker-node-policies
##    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
##    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
##    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
#  ]
#}