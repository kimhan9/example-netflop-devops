module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.29.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_id

  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 2
      desired_size = 2

      instance_types = ["t2.medium"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}