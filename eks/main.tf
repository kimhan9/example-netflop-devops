module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.10.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_id

  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t2.medium"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    terraform   = "true"
    environment = "dev"
  }
}