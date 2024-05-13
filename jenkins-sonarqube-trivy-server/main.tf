# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "my-vpc"
  cidr = var.vpc_cidr
  azs  = var.azs

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "terraform"                            = "true"
    "environment"                          = "dev"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/elb"               = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"      = 1
  }

}

# Security Group
module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "jenkins-sg"
  description = "Security group for jenkins server"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Jenkins port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      description = "SonarQube port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  create_spot_instance = true

  name = "jenkins-server"
  instance_type          = var.instance_type
  ami                    = var.ami
  key_name               = var.key_pair
  monitoring             = true
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data              = file("userdata.sh")
  root_block_device = [
    { volume_size = 25
      volume_type = "gp3"
    }
  ]

  tags = {
    terraform   = "true"
    environment = "dev"
    name        = "jenkins-server"
  }
}

resource "aws_eip" "eip" {
  instance = module.ec2.id
  domain   = "vpc"
}