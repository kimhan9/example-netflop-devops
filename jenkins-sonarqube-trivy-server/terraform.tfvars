vpc_cidr        = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
instance_type   = "t2.medium"
ami             = "ami-003c463c8207b4dfa" # Ubuntu Server 24.04 LTS
key_pair        = "kim2"