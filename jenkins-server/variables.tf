variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "private_subnets" {
  description = "Private Subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public Subnets"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "key_pair" {
  description = "Key Pair"
  type        = string
}