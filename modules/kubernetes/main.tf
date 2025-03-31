module "eks" {
 source  = "terraform-aws-modules/eks/aws"
 version = "~> 20.35.0"

 cluster_name    = "${var.cluster_name}"
 cluster_version = "1.31"

 # Optional
 cluster_endpoint_public_access = true

 # Optional: Adds the current caller identity as an administrator via cluster access entry
 enable_cluster_creator_admin_permissions = true

 eks_managed_node_groups = {
   example = {
     instance_types = ["t3.nano"]
     min_size       = 1
     max_size       = 3
     desired_size   = 2
   }
 }

 vpc_id     = var.vpc_id
 subnet_ids = var.subnet_id

 tags = {
   Environment = "dev"
   Terraform   = "true"
 }
}