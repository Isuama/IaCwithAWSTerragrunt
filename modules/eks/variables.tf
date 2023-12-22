variable "env" {
    description = "Environment Name"
    type = string
}

variable "eks_version" {
    description = "K8s Master Version"
}
variable "eks_name" {
    description = "EKS Cluster Name"
}

variable "subnet_ids" {
    description = "List of subnet IDs"
    type = list(string)
}
variable "cluster_role_iam_policies"{
    description = "List of IAM policies to attach as Cluster Role"
    type = map(any)
    default = {
        1 = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
        2 = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    }
}
variable "worker_node_iam_policies"{
    description = "List of IAM policies to attach as Worker Node Role"
    type = map(any)
    default = {
        1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
}

variable "node_groups"{
    description = "EKS node groups"
    type = map(any)
}
#variable public_subnet_tags{
#  description = "Tags for the public subnet"
#}
#
#variable "private_subnets" {
#  description = "Private Subnet CIDRs"
#}
#
#variable private_subnet_tags{
#  description = "Tags for the private subnet"
#}
#
#variable "azs" {
#  description = "Availability Zones"
#}