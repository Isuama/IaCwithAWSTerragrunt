variable "cluster_role_name" {
  description = "The name of the IAM role for the EKS cluster"
  type        = string
}

variable "workerNode_role_name" {
  description = "The name of the IAM role for the worker nodes in EKS"
  type        = string
}