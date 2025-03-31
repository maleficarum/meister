data "aws_eks_cluster" "target_cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "target_cluster" {
  name = module.eks.cluster_name
}